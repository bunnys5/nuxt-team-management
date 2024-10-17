<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import type { User } from "~/types";
import axios from "axios";
import UsersFormEdit from "~/components/users/UsersFormEdit.vue";
import Cookies from "js-cookie";
const defaultColumns = [
  {
    key: "username",
    label: "Username",
  },
  {
    key: "firstname",
    label: "First Name",
  },
  {
    key: "lastname",
    label: "Last Name",
  },
  {
    key: "email",
    label: "Email",
  },
  {
    key: "phone",
    label: "Phone",
  },
  {
    key: "team_name",
    label: "Team",
  },
  {
    key: "role",
    label: "Job Position",
  },

  {
    key: "edit",
    label: "",
  },
];

const token = Cookies.get("jwt");
const q = ref("");
const selected = ref<User[]>([]);
const selectedColumns = ref(defaultColumns);
const sort = ref({ column: "id", direction: "asc" as const });
const input = ref<{ input: HTMLInputElement }>();
const isNewUserModalOpen = ref(false);
const isNewUserModalOpenEdit = ref(false);
const isNewUserModalOpenDelete = ref(false);

const columns = computed(() =>
  defaultColumns.filter((column) => selectedColumns.value.includes(column))
);

const fetchData = async () => {
  try {
    const response = await axios.get("http://localhost:8080/api/users", {
      headers: {
        Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
      },
    });
    const userData = response.data.users;

    // You can assign the user data to `users` for display
    users.value = userData;
    console.log(users);
  } catch (error) {
    console.error("Error fetching users:", error);
  }
};

onMounted(async () => {
  fetchData();
});

const users = ref<User[]>([]); // Define users as a ref to store user data

function onSelect(row: User) {
  const index = selected.value.findIndex((item) => item.id === row.id);
  if (index === -1) {
    selected.value.push(row);
  } else {
    selected.value.splice(index, 1);
  }
}

defineShortcuts({
  "/": () => {
    input.value?.input?.focus();
  },
});

const selectedUser = ref<User | null>(null); // Track the user to edit

const editUser = async (userId: number) => {
  try {
    const response = await axios.get(
      `http://localhost:8080/api/users/${userId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
        },
      }
    );
    selectedUser.value = response.data.user; // Set the selected user
    isNewUserModalOpenEdit.value = true; // Open the edit modal
  } catch (error) {
    console.error("Error fetching user data:", error);
  }
};
const deleteUser = async (userId: number) => {
  try {
    // Fetch user data if needed, here just set the selected user
    const response = await axios.get(
      `http://localhost:8080/api/users/${userId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
        },
      }
    );
    selectedUser.value = response.data.user; // Assuming the user data is structured this way
    isNewUserModalOpenDelete.value = true; // Open the delete modal
  } catch (error) {
    console.error("Error fetching user data:", error);
  }
};
</script>

<template>
  <UDashboardPage>
    <UDashboardPanel grow>
      <UDashboardNavbar title="Users" :badge="users.length">
        <template #right>
          <UButton
            label="New user"
            trailing-icon="i-heroicons-plus"
            color="gray"
            @click="isNewUserModalOpen = true"
          />
        </template>
      </UDashboardNavbar>
      <UDashboardModal
        v-model="isNewUserModalOpen"
        title="New user"
        description="Add a new user to your database"
        :ui="{ width: 'sm:max-w-md' }"
      >
        <!-- ~/components/users/UsersForm.vue -->
        <UsersForm
          @close="isNewUserModalOpen = false"
          @userCreated="fetchData()"
        />
      </UDashboardModal>
      <UDashboardModal
        v-model="isNewUserModalOpenEdit"
        title="Edit user"
        description="Edit user"
      >
        <UsersFormEdit
          :user="selectedUser"
          @close="isNewUserModalOpenEdit = false"
        />
      </UDashboardModal>
      <UDashboardModal
        v-model="isNewUserModalOpenDelete"
        :user="selectedUser"
        title="Delete user"
      >
        <UsersFormDelete
          @close="isNewUserModalOpenDelete = false"
          :user="selectedUser"
        />
      </UDashboardModal>

      <UTable
        :rows="users"
        :columns="columns"
        :loading="pending"
        sort-mode="manual"
        class="w-full"
        :ui="{ divide: 'divide-gray-200 dark:divide-gray-800' }"
        @select="onSelect"
      >
        <template #name-data="{ row }">
          <div class="flex items-center gap-3">
            <span class="text-gray-900 dark:text-white font-medium">{{
              row.username
            }}</span>
          </div>
        </template>

        <template #firstname-data="{ row }">
          <span>{{ row.firstname }}</span>
        </template>

        <template #lastname-data="{ row }">
          <span>{{ row.lastname }}</span>
        </template>

        <template #email-data="{ row }">
          <span>{{ row.email }}</span>
        </template>

        <template #phone-data="{ row }">
          <span>{{ row.phone }}</span>
        </template>
        <template #team_name-data="{ row }">
          <UBadge
            :label="row.team_name"
            :color="blue"
            variant="subtle"
            class="capitalize"
          />
        </template>
        <template #role-data="{ row }">
          <UBadge
            :label="row.role"
            :color="green"
            variant="subtle"
            class="capitalize"
          />
        </template>

        <!-- open UsersFormEdit and send params id too -->
        <template #edit-data="{ row }">
          <div class="space-x-3">
            <UButton
              size="sm"
              color="blue"
              icon="i-heroicons-pencil"
              @click="editUser(row.id)"
            />
            <UButton
              size="sm"
              color="red"
              icon="i-heroicons-trash"
              @click="deleteUser(row.id)"
            />
          </div>
        </template>
      </UTable>
    </UDashboardPanel>
  </UDashboardPage>
</template>
