<script setup lang="ts">
import { useRouter } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";

const router = useRouter();
definePageMeta({
  layout: "auth",
});

useSeoMeta({
  title: "Login",
});

const fields = [
  {
    name: "email",
    type: "text",
    label: "Email or Username",
    placeholder: "Enter your email or username",
  },
  {
    name: "password",
    label: "Password",
    type: "password",
    placeholder: "Enter your password",
  },
];

const validate = (state: any) => {
  const errors = [];
  if (!state.email)
    errors.push({ path: "email", message: "Email is required" });
  if (!state.password)
    errors.push({ path: "password", message: "Password is required" });
  return errors;
};

const providers = [
  {
    label: "Continue with GitHub",
    icon: "i-simple-icons-github",
    color: "white" as const,
    click: () => {
      console.log("Redirect to GitHub");
    },
  },
];

function onSubmit(data: any) {
  // สร้าง body request สำหรับ API
  const loginData = {
    identifier: data.email, // ใช้ email หรือ username ที่ผู้ใช้กรอก
    password: data.password, // ใช้ password ที่ผู้ใช้กรอก
  };

  // ส่ง request ไปยัง API localhost:8080/login
  axios
    .post("http://localhost:8080/login", loginData)
    .then((response) => {
      console.log("Login successful:", response.data);
      if (response.data.message == "Login successful") {
        Cookies.set("username", response.data.user.username);
        router.push("/home");
      }
      Cookies.set("jwt", response.data.token, { expires: 1 });

      // หลังจากล็อกอินสำเร็จสามารถนำทางไปยังหน้าอื่น เช่น หน้า dashboard
    })
    .catch((error) => {
      console.error("Error during login:", error);
      alert("Login failed. Please check your credentials.");
    });
}
</script>

<!-- eslint-disable vue/multiline-html-element-content-newline -->
<!-- eslint-disable vue/singleline-html-element-content-newline -->
<template>
  <div class="flex h-screen justify-center items-center">
    <UCard class="max-w-sm w-full bg-white/75 dark:bg-white/5 backdrop-blur">
      <UAuthForm
        :fields="fields"
        :validate="validate"
        title="Welcome back"
        align="top"
        icon="i-heroicons-lock-closed"
        :ui="{ base: 'text-center', footer: 'text-center' }"
        :submit-button="{ trailingIcon: 'i-heroicons-arrow-right-20-solid' }"
        @submit="onSubmit"
      >
      </UAuthForm>
    </UCard>
  </div>
</template>
