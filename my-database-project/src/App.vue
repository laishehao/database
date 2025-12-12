<template>
  <div>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'App',
  components: {
 
  },
  created(){
    if (this.$route.path !== '/index'){
      this.$router.replace('/index')
    }  
  }
}
</script>

<style lang="stylus">
html, body
  overflow hidden
  height 100vh
</style>
