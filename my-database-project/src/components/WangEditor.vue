/* wangEditor组件 */
<template>
  <div class="wang-editor-container">
    <div :id="toolbarId"></div>
    <div :id="contentId" :style="{ minHeight: height }"></div>
  </div>
</template>

<script>
import E from "wangeditor";

export default {
  name: "WangEditor",
  props: {
    // v-model 绑定的内容
    value: {
      type: String,
      default: "",
    },
    // 占位符
    placeholder: {
      type: String,
      default: "请输入内容...",
    },
    // 图片上传服务器地址
    uploadServer: {
      type: String,
      default: "/api/upload/image",
    },
    // 上传文件字段名
    uploadFileName: {
      type: String,
      default: "file",
    },
    // 编辑器高度
    height: {
      type: String,
      default: "300px",
    },
    // 是否禁用编辑器
    disabled: {
      type: Boolean,
      default: false,
    },
    // 自定义菜单配置
    menus: {
      type: Array,
      default: () => [
        "head",
        "bold",
        "fontSize",
        "fontName",
        "italic",
        "underline",
        "strikeThrough",
        "indent",
        "lineHeight",
        "foreColor",
        "backColor",
        "link",
        "list",
        "justify",
        "quote",
        "emoticon",
        "image",
        "table",
        "code",
        "splitLine",
        "undo",
        "redo",
      ],
    },
    // 图片上传最大尺寸 (字节)
    uploadImgMaxSize: {
      type: Number,
      default: 5 * 1024 * 1024, // 5MB
    },
    // 一次最多上传图片数量
    uploadImgMaxLength: {
      type: Number,
      default: 5,
    },
    // 上传超时时间 (毫秒)
    uploadImgTimeout: {
      type: Number,
      default: 10 * 1000, // 10秒
    },
    // 允许的图片类型
    uploadImgAccept: {
      type: Array,
      default: () => ["jpg", "jpeg", "png", "gif", "bmp", "webp"],
    },
    // 自定义请求头
    uploadImgHeaders: {
      type: Object,
      default: () => ({}),
    },
    // 自定义上传参数
    uploadImgParams: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    // 生成唯一ID，避免多个编辑器实例冲突
    const uniqueId = `wangeditor-${Date.now()}-${Math.random()
      .toString(36)
      .substr(2, 9)}`;
    return {
      editor: null,
      toolbarId: `${uniqueId}-toolbar`,
      contentId: `${uniqueId}-content`,
      isSettingContent: false, // 防止循环更新
    };
  },
  watch: {
    // 监听外部 value 变化，同步到编辑器
    value(newVal) {
      if (this.editor && !this.isSettingContent) {
        const currentHtml = this.editor.txt.html();
        if (newVal !== currentHtml) {
          this.editor.txt.html(newVal || "");
        }
      }
    },
    // 监听 disabled 变化
    disabled(newVal) {
      if (this.editor) {
        if (newVal) {
          this.editor.disable();
        } else {
          this.editor.enable();
        }
      }
    },
  },
  mounted() {
    this.initEditor();
  },
  beforeDestroy() {
    // 销毁编辑器实例，防止内存泄漏
    if (this.editor) {
      this.editor.destroy();
      this.editor = null;
    }
  },
  methods: {
    // 初始化编辑器
    initEditor() {
      const editor = new E(`#${this.toolbarId}`, `#${this.contentId}`);

      // 基础配置
      editor.config.placeholder = this.placeholder;
      editor.config.zIndex = 100;
      editor.config.menus = this.menus;

      // 图片上传配置
      editor.config.uploadImgServer = this.uploadServer;
      editor.config.uploadFileName = this.uploadFileName;
      editor.config.uploadImgMaxSize = this.uploadImgMaxSize;
      editor.config.uploadImgAccept = this.uploadImgAccept;
      editor.config.uploadImgMaxLength = this.uploadImgMaxLength;
      editor.config.uploadImgTimeout = this.uploadImgTimeout;
      editor.config.uploadImgHeaders = this.uploadImgHeaders;
      editor.config.uploadImgParams = this.uploadImgParams;

      // 上传钩子
      editor.config.uploadImgHooks = {
        before: (xhr, editor, files) => {
          this.$emit("upload-before", { xhr, editor, files });
        },
        success: (xhr, editor, result) => {
          this.$emit("upload-success", { xhr, editor, result });
        },
        fail: (xhr, editor, result) => {
          console.error("图片上传失败", result);
          this.$emit("upload-fail", { xhr, editor, result });
        },
        error: (xhr, editor) => {
          console.error("图片上传出错", xhr);
          this.$emit("upload-error", { xhr, editor });
        },
        timeout: (xhr, editor) => {
          console.error("图片上传超时");
          this.$emit("upload-timeout", { xhr, editor });
        },
      };

      // 监听内容变化
      editor.config.onchange = (html) => {
        this.isSettingContent = true;
        this.$emit("input", html); // 支持 v-model
        this.$emit("change", html);
        this.$nextTick(() => {
          this.isSettingContent = false;
        });
      };

      // 创建编辑器
      editor.create();

      // 保存实例
      this.editor = editor;

      // 回显初始内容
      if (this.value) {
        editor.txt.html(this.value);
      }

      // 如果初始为禁用状态
      if (this.disabled) {
        editor.disable();
      }

      // 通知父组件编辑器已就绪
      this.$emit("ready", editor);
    },

    // 暴露方法：获取 HTML 内容
    getHtml() {
      return this.editor ? this.editor.txt.html() : "";
    },

    // 暴露方法：获取纯文本内容
    getText() {
      return this.editor ? this.editor.txt.text() : "";
    },

    // 暴露方法：设置内容
    setHtml(html) {
      if (this.editor) {
        this.editor.txt.html(html || "");
      }
    },

    // 暴露方法：清空内容
    clear() {
      if (this.editor) {
        this.editor.txt.clear();
      }
    },

    // 暴露方法：禁用编辑器
    disable() {
      if (this.editor) {
        this.editor.disable();
      }
    },

    // 暴露方法：启用编辑器
    enable() {
      if (this.editor) {
        this.editor.enable();
      }
    },
  },
};
</script>

<style scoped>
.wang-editor-container {
  width: 100%;
}

/* 工具栏样式 */
.wang-editor-container > div:first-child {
  border: 1px solid #dcdfe6;
  border-bottom: none;
  border-radius: 4px 4px 0 0;
}

/* 内容区样式 */
.wang-editor-container > div:last-child {
  border: 1px solid #dcdfe6;
  border-radius: 0 0 4px 4px;
}

/* 内容区域图片样式 */
::v-deep .wang-editor-container img {
  max-width: 100%;
  height: auto;
}
</style>
