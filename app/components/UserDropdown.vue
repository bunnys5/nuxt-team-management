<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import Cookies from "js-cookie";
import { useRouter } from "vue-router";

// ตัวแปรสำหรับเก็บ username
const username = ref("");
const router = useRouter();

// เมื่อ mounted ให้ดึงค่า username จาก Cookies
onMounted(() => {
  username.value = Cookies.get("username") || "Benjamin"; // ตั้งค่า default เป็น Benjamin หากไม่มี cookie
});

// ฟังก์ชัน logout เพื่อลบ cookie และ redirect ไปที่หน้าแรก "/"
const logout = () => {
  Cookies.remove("username"); // ลบ cookie
  router.push("/"); // นำผู้ใช้กลับไปหน้าแรก
};

// เมนู dropdown สำหรับ sign out
const items = computed(() => [
  [
    {
      label: "Sign out",
      icon: "i-heroicons-arrow-left-on-rectangle",
      action: logout, // เพิ่ม action เรียกใช้ logout เมื่อคลิก sign out
    },
  ],
]);
</script>

<template>
  <UDropdown
    mode="hover"
    :items="items"
    :ui="{ width: 'w-full', item: { disabled: 'cursor-text select-text' } }"
    :popper="{ strategy: 'absolute', placement: 'top' }"
    class="w-full"
  >
    <template #default="{ open }">
      <UButton
        color="gray"
        variant="ghost"
        class="w-full"
        :label="username"
        :class="[open && 'bg-gray-50 dark:bg-gray-800']"
      >
        <template #leading>
          <UAvatar
            src="https://via.placeholder.com/128?text=User+Icon"
            size="2xs"
          />
        </template>

        <template #trailing>
          <UIcon name="i-heroicons-ellipsis-vertical" class="w-5 h-5 ml-auto" />
        </template>
      </UButton>
    </template>

    <template #account>
      <div class="text-left">
        <p>Signed in as</p>
        <p class="truncate font-medium text-gray-900 dark:text-white">
          {{ username }}
        </p>
      </div>
    </template>
  </UDropdown>
</template>
