/*
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-11 00:05:32
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 00:22:54
 * @FilePath: \my-database-project\src\api\http.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import service from './common' // 引入封装好的 axios 实例 (包含拦截器配置等)
import apiConfig from '@/config/api.config' // 引入 API 接口配置文件

/**
 * 统一 HTTP 请求处理函数
 * @param {String} params.type - 在 api.config.js 中定义的接口键名 
 * @param {Object} params.data - 请求携带的数据 
 */
export default async function Http({ apiType, data }) {
  //校验接口配置是否存在
  console.log(apiType)
  console.log(data)
  if (!(apiType in apiConfig)) {
    throw new Error('API请求错误: 未在配置文件中找到该 type')
  }

  // 获取接口配置信息
  // noMessage: 是否屏蔽错误提示 (默认 false，即显示错误)
  let { url, method, rest = false} = apiConfig[apiType]

  try {
    method = method.toLowerCase() // 统一转换为小写，防止配置写成 'POST' 导致 axios 无法识别

    //替换RESTFUL风格的url
    if(rest){
      let restSymbol = url.match(/:(.*)$/)[1]
      url = url.replace(/:(.*)$/, data[restSymbol])
    }
    // 适配 Axios 参数格式
    // 'get' 请求参数需要放在 { params: ... } 中
    // 'post'/'put' 等请求参数直接作为第二个参数传递
    data = method === 'get' ? { params: data } : data

    // 发起网络请求
    let result = await service[method](url, data)
    return result
  } catch (error) {
    if (error.response) {
      console.log('捕捉到response',error.response)
      let message = error.response.data?.msg || '' 
      this.$notify.error({ title: '错误', message })
    } 
    return Promise.reject(error);
  }
}