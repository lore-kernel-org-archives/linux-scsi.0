From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 4/4] scsi: hisi_sas: Add support for DIF/DIX feature for
 v3 hw
Date: Mon, 26 Nov 2018 15:42:17 +0000
Message-ID: <132099e2-0a20-3048-f58a-5db3230767e2@huawei.com>
References: <1542725944-244183-5-git-send-email-john.garry@huawei.com>
 <201811250107.Xz53A78z%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201811250107.Xz53A78z%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 24/11/2018 17:50, kbuild test robot wrote:
> Hi Xiang,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on next-20181123]
> [cannot apply to v4.20-rc3]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/John-Garry/hisi_sas-DIF-DIX-support/20181123-202805
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64

For sparse errors - which are detected, below - we need C=2 option, right?

It would be good to include that in the instructions.

Thanks,
John

>
> All warnings (new ones prefixed by >>):
>
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: incorrect type in argument 1 (different base types)
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26:    expected unsigned long long [unsigned] [usertype] val
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26:    got restricted __le64 [usertype] sas_addr
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:26: warning: cast from restricted __le64
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:24: warning: incorrect type in assignment (different base types)
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:24:    expected restricted __le64 [usertype] sas_addr
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:694:24:    got unsigned long long
>>> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1165:26: warning: invalid assignment: |=
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1165:26:    left side has type restricted __le32
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1165:26:    right side has type int
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1166:26: warning: invalid assignment: |=
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1166:26:    left side has type restricted __le32
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1166:26:    right side has type int
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1759:37: warning: incorrect type in initializer (different base types)
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1759:37:    expected unsigned int [unsigned] [usertype] dma_rx_err_type
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1759:37:    got restricted __le32 [usertype] dma_rx_err_type
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1760:40: warning: incorrect type in initializer (different base types)
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1760:40:    expected unsigned int [unsigned] [usertype] trans_tx_fail_type
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1760:40:    got restricted __le32 [usertype] trans_tx_fail_type
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1767:40: warning: restricted __le32 degrades to integer
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1781:40: warning: restricted __le32 degrades to integer
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1840:30: warning: restricted __le32 degrades to integer
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1864:26: warning: restricted __le32 degrades to integer
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1976:37: warning: restricted __le32 degrades to integer
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2372:25: warning: symbol 'host_attrs_v3_hw' was not declared. Should it be static?
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2858:22: warning: incorrect type in assignment (different base types)
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2858:22:    expected unsigned int [unsigned] [usertype] device_state
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2858:22:    got restricted pci_power_t
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2863:35: warning: incorrect type in argument 2 (different base types)
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2863:35:    expected restricted pci_power_t [usertype] state
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2863:35:    got unsigned int [unsigned] [usertype] device_state
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2878:32: warning: incorrect type in initializer (different base types)
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2878:32:    expected unsigned int [unsigned] [usertype] device_state
>    drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2878:32:    got restricted pci_power_t [usertype] current_state
>
> vim +1165 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>
>   1072	
>   1073	static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
>   1074				  struct hisi_sas_slot *slot)
>   1075	{
>   1076		struct sas_task *task = slot->task;
>   1077		struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
>   1078		struct domain_device *device = task->dev;
>   1079		struct hisi_sas_device *sas_dev = device->lldd_dev;
>   1080		struct hisi_sas_port *port = slot->port;
>   1081		struct sas_ssp_task *ssp_task = &task->ssp_task;
>   1082		struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
>   1083		struct hisi_sas_tmf_task *tmf = slot->tmf;
>   1084		int has_data = 0, priority = !!tmf;
>   1085		u8 *buf_cmd;
>   1086		u32 dw1 = 0, dw2 = 0, len = 0;
>   1087	
>   1088		hdr->dw0 = cpu_to_le32((1 << CMD_HDR_RESP_REPORT_OFF) |
>   1089				       (2 << CMD_HDR_TLR_CTRL_OFF) |
>   1090				       (port->id << CMD_HDR_PORT_OFF) |
>   1091				       (priority << CMD_HDR_PRIORITY_OFF) |
>   1092				       (1 << CMD_HDR_CMD_OFF)); /* ssp */
>   1093	
>   1094		dw1 = 1 << CMD_HDR_VDTL_OFF;
>   1095		if (tmf) {
>   1096			dw1 |= 2 << CMD_HDR_FRAME_TYPE_OFF;
>   1097			dw1 |= DIR_NO_DATA << CMD_HDR_DIR_OFF;
>   1098		} else {
>   1099			dw1 |= 1 << CMD_HDR_FRAME_TYPE_OFF;
>   1100			switch (scsi_cmnd->sc_data_direction) {
>   1101			case DMA_TO_DEVICE:
>   1102				has_data = 1;
>   1103				dw1 |= DIR_TO_DEVICE << CMD_HDR_DIR_OFF;
>   1104				break;
>   1105			case DMA_FROM_DEVICE:
>   1106				has_data = 1;
>   1107				dw1 |= DIR_TO_INI << CMD_HDR_DIR_OFF;
>   1108				break;
>   1109			default:
>   1110				dw1 &= ~CMD_HDR_DIR_MSK;
>   1111			}
>   1112		}
>   1113	
>   1114		/* map itct entry */
>   1115		dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
>   1116		hdr->dw1 = cpu_to_le32(dw1);
>   1117	
>   1118		dw2 = (((sizeof(struct ssp_command_iu) + sizeof(struct ssp_frame_hdr)
>   1119		      + 3) / 4) << CMD_HDR_CFL_OFF) |
>   1120		      ((HISI_SAS_MAX_SSP_RESP_SZ / 4) << CMD_HDR_MRFL_OFF) |
>   1121		      (2 << CMD_HDR_SG_MOD_OFF);
>   1122		hdr->dw2 = cpu_to_le32(dw2);
>   1123		hdr->transfer_tags = cpu_to_le32(slot->idx);
>   1124	
>   1125		if (has_data) {
>   1126			prep_prd_sge_v3_hw(hisi_hba, slot, hdr, task->scatter,
>   1127					   slot->n_elem);
>   1128	
>   1129			if (scsi_prot_sg_count(scsi_cmnd))
>   1130				prep_prd_sge_dif_v3_hw(hisi_hba, slot, hdr,
>   1131						       scsi_prot_sglist(scsi_cmnd),
>   1132						       slot->n_elem_dif);
>   1133		}
>   1134	
>   1135		hdr->cmd_table_addr = cpu_to_le64(hisi_sas_cmd_hdr_addr_dma(slot));
>   1136		hdr->sts_buffer_addr = cpu_to_le64(hisi_sas_status_buf_addr_dma(slot));
>   1137	
>   1138		buf_cmd = hisi_sas_cmd_hdr_addr_mem(slot) +
>   1139			sizeof(struct ssp_frame_hdr);
>   1140	
>   1141		memcpy(buf_cmd, &task->ssp_task.LUN, 8);
>   1142		if (!tmf) {
>   1143			buf_cmd[9] = ssp_task->task_attr | (ssp_task->task_prio << 3);
>   1144			memcpy(buf_cmd + 12, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
>   1145		} else {
>   1146			buf_cmd[10] = tmf->tmf;
>   1147			switch (tmf->tmf) {
>   1148			case TMF_ABORT_TASK:
>   1149			case TMF_QUERY_TASK:
>   1150				buf_cmd[12] =
>   1151					(tmf->tag_of_task_to_be_managed >> 8) & 0xff;
>   1152				buf_cmd[13] =
>   1153					tmf->tag_of_task_to_be_managed & 0xff;
>   1154				break;
>   1155			default:
>   1156				break;
>   1157			}
>   1158		}
>   1159	
>   1160		if (has_data && !scsi_prot_op_normal(scsi_cmnd)) {
>   1161			struct hisi_sas_protect_iu_v3_hw prot;
>   1162			unsigned char prot_op = scsi_get_prot_op(scsi_cmnd);
>   1163			u8 *buf_cmd_prot;
>   1164	
>> 1165			hdr->dw7 |= 1 << CMD_HDR_ADDR_MODE_SEL_OFF;
>   1166			hdr->dw1 |= CMD_HDR_PIR_MSK;
>   1167			buf_cmd_prot = hisi_sas_cmd_hdr_addr_mem(slot) +
>   1168				       sizeof(struct ssp_frame_hdr) +
>   1169				       sizeof(struct ssp_command_iu);
>   1170	
>   1171			memset(&prot, 0, sizeof(struct hisi_sas_protect_iu_v3_hw));
>   1172			fill_prot_v3_hw(scsi_cmnd, &prot);
>   1173			memcpy(buf_cmd_prot, &prot,
>   1174			       sizeof(struct hisi_sas_protect_iu_v3_hw));
>   1175	
>   1176			if ((prot_op == SCSI_PROT_READ_INSERT) ||
>   1177			    (prot_op == SCSI_PROT_WRITE_INSERT) ||
>   1178			    (prot_op == SCSI_PROT_WRITE_PASS) ||
>   1179			    (prot_op == SCSI_PROT_READ_PASS)) {
>   1180				unsigned int interval = scsi_prot_interval(scsi_cmnd);
>   1181				unsigned int ilog2_interval = ilog2(interval);
>   1182	
>   1183				len = (task->total_xfer_len >> ilog2_interval) * 8;
>   1184			}
>   1185		}
>   1186	
>   1187		hdr->data_transfer_len = cpu_to_le32(task->total_xfer_len + len);
>   1188	}
>   1189	
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
