/*
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-09-26 16:58:03
 * @LastEditors: Garyonit 3253975221@qq.com
 * @LastEditTime: 2025-12-11 21:46:08
 * @FilePath: \vue-blog\src\api\common.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import axios from 'axios'
import { Notification } from 'element-ui' // 1. 引入 Notification 组件
import baseConfig from '@/config/base.config'

const { BASE_URL, TIMEOUT } = baseConfig

const service = axios.create({
  baseURL: BASE_URL,
  timeout: TIMEOUT
})

// request 拦截器
/*
*url: 请求的地址（例如 /api/user/login）。
*method: 请求方法（get, post, put 等）。
*headers: 请求头（最重要的通常是 Authorization: Bearer token，用来验证身份）。
*data: POST 请求发送给服务器的主体数据（Payload）。
*params: GET 请求拼接在 URL 后面的参数。
*timeout: 超时时间。
*/
service.interceptors.request.use(async (config) => {
  console.log('request 拦截!!', config)
  return config
}, (error) => {
  return Promise.reject(error);
});

// response 拦截器
/*
*status: HTTP 状态码（如 200 表示成功，404 表示找不到）。
*statusText: 状态描述（如 "OK"）。
*headers: 服务器返回的响应头。
*config: 当初发送请求时的那个配置对象。
*request: 原生的 XMLHttpRequest 对象。
*data: 重点！ 这里面才是服务器真正返回给你的 JSON 数据。
*/
service.interceptors.response.use((response) => {
  let result = response?.data || {}
  console.log('response拦截!!', response)
  return result?.data;
}, (error) => {  
  // 判断是否是超时错误
  if (error.code === 'ECONNABORTED' && error.message.includes('timeout')) {
    Notification.error({
      title: '请求超时',
      message: '服务器响应时间过长，请检查网络或稍后重试',
      duration: 3000
    });
  } 
  // 判断是否有响应对象（如果没有 response 通常是断网或跨域彻底失败）
  else if (!error.response) {
    Notification.error({
      title: '网络错误',
      message: '无法连接到服务器，请检查网络设置',
      duration: 3000
    });
  }
  // 其他类型的 HTTP 错误 (如 404, 500) 可以在这里处理，也可以留给组件自己处理
  else {
    Notification.error({
      title: '请求错误',
      message: error.response.statusText || error.message
    });
  }

  return Promise.reject(error);
});

export default service