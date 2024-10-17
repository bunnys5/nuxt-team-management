<script setup lang="ts">
import { format } from "date-fns";
import {
  VisXYContainer,
  VisLine,
  VisAxis,
  VisArea,
  VisCrosshair,
  VisTooltip,
} from "@unovis/vue";
import type { Period, Range } from "~/types";
import axios from "axios";
import Cookies from "js-cookie";

const token = Cookies.get("jwt");
const cardRef = ref<HTMLElement | null>(null);

const props = defineProps({
  period: {
    type: String as PropType<Period>,
    required: true,
  },
  range: {
    type: Object as PropType<Range>,
    required: true,
  },
});

type DataRecord = {
  date: Date;
  amount: number;
};

const { width } = useElementSize(cardRef);

const fetchData = async () => {
  try {
    const response = await axios.get("http://localhost:8080/api/users", {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    const userData = response.data.users;

    // นับจำนวนผู้ใช้งานในแต่ละเดือน
    const monthlyUserCounts = userData.reduce(
      (acc: Record<string, number>, user: any) => {
        const month = new Date(user.created_at).toISOString().slice(0, 7);
        acc[month] = (acc[month] || 0) + 1;
        return acc;
      },
      {}
    );

    // แปลงข้อมูลให้อยู่ในรูปแบบที่กราฟต้องการ
    const dataForGraph = Object.entries(monthlyUserCounts).map(
      ([month, count]) => ({
        date: new Date(month + "-01"),
        amount: count,
      })
    );

    // เรียงข้อมูลตามวันที่
    dataForGraph.sort((a, b) => a.date.getTime() - b.date.getTime());

    return dataForGraph;
  } catch (error) {
    console.error("Error fetching users:", error);
    return [];
  }
};

const { data } = await useAsyncData<DataRecord[]>(fetchData, {
  watch: [() => props.period, () => props.range],
  default: () => [],
});

const x = (_: DataRecord, i: number) => i;
const y = (d: DataRecord) => d.amount;

const total = computed(() =>
  data.value.reduce((acc: number, { amount }) => acc + amount, 0)
);

const formatNumber = new Intl.NumberFormat("en", {
  maximumFractionDigits: 0,
}).format;

// Updated formatDate function to include month and year
const formatDate = (date: Date): string => {
  return {
    daily: format(date, "d MMM"),
    weekly: format(date, "d MMM"),
    monthly: format(date, "MMM yyyy"), // This already formats as needed
  }[props.period];
};

const xTicks = (i: number) => {
  if (i === 0 || i === data.value.length - 1 || !data.value[i]) {
    return "";
  }
  // Format for x-axis tick labels to show month and year
  return format(data.value[i].date, "MMM yyyy");
};

// Updated template to include year
const template = (d: DataRecord) =>
  `${format(d.date, "MMM yyyy")}: ${formatNumber(d.amount)}`;
</script>

<template>
  <UDashboardCard
    ref="cardRef"
    :ui="{ body: { padding: '!pb-3 !px-0' } as any }"
  >
    <template #header>
      <div>
        <p class="text-sm text-gray-500 dark:text-gray-400 font-medium mb-1">
          Users Created
        </p>
        <p class="text-3xl text-gray-900 dark:text-white font-semibold">
          {{ total }}
        </p>
      </div>
    </template>

    <VisXYContainer
      :data="data"
      :padding="{ top: 10 }"
      class="h-96"
      :width="width"
    >
      <VisLine :x="x" :y="y" color="rgb(var(--color-primary-DEFAULT))" />
      <VisArea
        :x="x"
        :y="y"
        color="rgb(var(--color-primary-DEFAULT))"
        :opacity="0.1"
      />

      <VisAxis type="x" :x="x" :tick-format="xTicks" />

      <VisCrosshair
        color="rgb(var(--color-primary-DEFAULT))"
        :template="template"
      />

      <VisTooltip />
    </VisXYContainer>
  </UDashboardCard>
</template>

<style scoped>
.unovis-xy-container {
  --vis-crosshair-line-stroke-color: rgb(var(--color-primary-500));
  --vis-crosshair-circle-stroke-color: #fff;

  --vis-axis-grid-color: rgb(var(--color-gray-200));
  --vis-axis-tick-color: rgb(var(--color-gray-200));
  --vis-axis-tick-label-color: rgb(var(--color-gray-400));

  --vis-tooltip-background-color: #fff;
  --vis-tooltip-border-color: rgb(var(--color-gray-200));
  --vis-tooltip-text-color: rgb(var(--color-gray-900));
}

.dark {
  .unovis-xy-container {
    --vis-crosshair-line-stroke-color: rgb(var(--color-primary-400));
    --vis-crosshair-circle-stroke-color: rgb(var(--color-gray-900));

    --vis-axis-grid-color: rgb(var(--color-gray-800));
    --vis-axis-tick-color: rgb(var(--color-gray-800));
    --vis-axis-tick-label-color: rgb(var(--color-gray-500));

    --vis-tooltip-background-color: rgb(var(--color-gray-900));
    --vis-tooltip-border-color: rgb(var(--color-gray-800));
    --vis-tooltip-text-color: #fff;
  }
}
</style>
