From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/3] megaraid_sas: Convert dev_printk to dev_<level>
Date: Tue, 27 Oct 2015 11:25:50 +0100
Message-ID: <1445941550.16404.37.camel@suse.de>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
	 <1445934375-17784-2-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445934375-17784-2-git-send-email-wangweidong1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Weidong Wang <wangweidong1@huawei.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-27 at 16:26 +0800, Weidong Wang wrote:
> Reduce object size a little by using dev_<level>
> calls instead of dev_printk(KERN_<LEVEL>.
>=20
> Signed-off-by: Weidong Wang <wangweidong1@huawei.com>
> ---
> =C2=A0drivers/scsi/megaraid/megaraid_sas_base.c | 68 +++++++++++++++-=
---
> ------------
> =C2=A01 file changed, 34 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index eaa81e5..ed9846d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1884,7 +1884,7 @@ static int
> megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
> =C2=A0	cmd =3D megasas_get_cmd(instance);
> =C2=A0
> =C2=A0	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev,
> "megasas_get_ld_vf_affiliation_111:"
> +		dev_dbg(&instance->pdev->dev,
> "megasas_get_ld_vf_affiliation_111:"
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"Failed to get cmd =
for scsi%d\n",
> =C2=A0			instance->host->host_no);
> =C2=A0		return -ENOMEM;
> @@ -1908,7 +1908,7 @@ static int
> megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(struct
> MR_LD_VF_AFFILIATION_111),
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&new_affiliation_111_h)
> ;
> =C2=A0		if (!new_affiliation_111) {
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "SR-IOV: Couldn't allocate "
> +			dev_dbg(&instance->pdev->dev, "SR-IOV:
> Couldn't allocate "
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"memory for new af=
filiation for
> scsi%d\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0instance->host->ho=
st_no);
> =C2=A0			megasas_return_cmd(instance, cmd);
> @@ -1995,7 +1995,7 @@ static int
> megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
> =C2=A0	cmd =3D megasas_get_cmd(instance);
> =C2=A0
> =C2=A0	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev,
> "megasas_get_ld_vf_affiliation12: "
> +		dev_dbg(&instance->pdev->dev,
> "megasas_get_ld_vf_affiliation12: "
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"Failed to get cmd =
for scsi%d\n",
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0instance->host->hos=
t_no);
> =C2=A0		return -ENOMEM;
> @@ -2020,7 +2020,7 @@ static int
> megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(struct
> MR_LD_VF_AFFILIATION),
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&new_affiliation_h);
> =C2=A0		if (!new_affiliation) {
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "SR-IOV: Couldn't allocate "
> +			dev_dbg(&instance->pdev->dev, "SR-IOV:
> Couldn't allocate "
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"memory for new af=
filiation for
> scsi%d\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0instance->host->ho=
st_no);
> =C2=A0			megasas_return_cmd(instance, cmd);
> @@ -2174,7 +2174,7 @@ int megasas_sriov_start_heartbeat(struct
> megasas_instance *instance,
> =C2=A0	cmd =3D megasas_get_cmd(instance);
> =C2=A0
> =C2=A0	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev,
> "megasas_sriov_start_heartbeat: "
> +		dev_dbg(&instance->pdev->dev,
> "megasas_sriov_start_heartbeat: "
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"Failed to get cmd =
for scsi%d\n",
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0instance->host->hos=
t_no);
> =C2=A0		return -ENOMEM;
> @@ -2188,7 +2188,7 @@ int megasas_sriov_start_heartbeat(struct
> megasas_instance *instance,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(struct
> MR_CTRL_HB_HOST_MEM),
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&instance-
> >hb_host_mem_h);
> =C2=A0		if (!instance->hb_host_mem) {
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "SR-IOV: Couldn't allocate"
> +			dev_dbg(&instance->pdev->dev, "SR-IOV:
> Couldn't allocate"
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0" memory for heart=
beat host memory
> for scsi%d\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0instance->host->ho=
st_no);
> =C2=A0			retval =3D -ENOMEM;
> @@ -2922,7 +2922,7 @@ megasas_complete_cmd(struct megasas_instance
> *instance, struct megasas_cmd *cmd,
> =C2=A0			break;
> =C2=A0
> =C2=A0		default:
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "MFI FW status %#x\n",
> +			dev_dbg(&instance->pdev->dev, "MFI FW status
> %#x\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hdr->cmd_status);
> =C2=A0			cmd->scmd->result =3D DID_ERROR << 16;
> =C2=A0			break;
> @@ -3332,7 +3332,7 @@ megasas_transition_to_ready(struct
> megasas_instance *instance, int ocr)
> =C2=A0		switch (fw_state) {
> =C2=A0
> =C2=A0		case MFI_STATE_FAULT:
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "FW in FAULT state!!\n");
> +			dev_dbg(&instance->pdev->dev, "FW in FAULT
> state!!\n");
> =C2=A0			if (ocr) {
> =C2=A0				max_wait =3D MEGASAS_RESET_WAIT_TIME;
> =C2=A0				cur_state =3D MFI_STATE_FAULT;
> @@ -3471,7 +3471,7 @@ megasas_transition_to_ready(struct
> megasas_instance *instance, int ocr)
> =C2=A0			break;
> =C2=A0
> =C2=A0		default:
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "Unknown state 0x%x\n",
> +			dev_dbg(&instance->pdev->dev, "Unknown state
> 0x%x\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fw_state);
> =C2=A0			return -ENODEV;
> =C2=A0		}
> @@ -3493,7 +3493,7 @@ megasas_transition_to_ready(struct
> megasas_instance *instance, int ocr)
> =C2=A0		=C2=A0* Return error if fw_state hasn't changed after
> max_wait
> =C2=A0		=C2=A0*/
> =C2=A0		if (curr_abs_state =3D=3D abs_state) {
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "FW state [%d] hasn't changed "
> +			dev_dbg(&instance->pdev->dev, "FW state [%d]
> hasn't changed "
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"in %d secs\n", fw=
_state, max_wait);
> =C2=A0			return -ENODEV;
> =C2=A0		}
> @@ -3595,7 +3595,7 @@ static int megasas_create_frame_pool(struct
> megasas_instance *instance)
> =C2=A0					instance->pdev, total_sz,
> 256, 0);
> =C2=A0
> =C2=A0	if (!instance->frame_dma_pool) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed
> to setup frame pool\n");
> +		dev_dbg(&instance->pdev->dev, "failed to setup frame
> pool\n");
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> =C2=A0
> @@ -3603,7 +3603,7 @@ static int megasas_create_frame_pool(struct
> megasas_instance *instance)
> =C2=A0						=C2=A0=C2=A0=C2=A0instance->pdev,
> 128, 4, 0);
> =C2=A0
> =C2=A0	if (!instance->sense_dma_pool) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed
> to setup sense pool\n");
> +		dev_dbg(&instance->pdev->dev, "failed to setup sense
> pool\n");
> =C2=A0
> =C2=A0		pci_pool_destroy(instance->frame_dma_pool);
> =C2=A0		instance->frame_dma_pool =3D NULL;
> @@ -3631,7 +3631,7 @@ static int megasas_create_frame_pool(struct
> megasas_instance *instance)
> =C2=A0		=C2=A0* whatever has been allocated
> =C2=A0		=C2=A0*/
> =C2=A0		if (!cmd->frame || !cmd->sense) {
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "pci_pool_alloc failed\n");
> +			dev_dbg(&instance->pdev->dev,
> "pci_pool_alloc failed\n");
> =C2=A0			megasas_teardown_frame_pool(instance);
> =C2=A0			return -ENOMEM;
> =C2=A0		}
> @@ -3710,7 +3710,7 @@ int megasas_alloc_cmds(struct megasas_instance
> *instance)
> =C2=A0	instance->cmd_list =3D kcalloc(max_cmd, sizeof(struct
> megasas_cmd*), GFP_KERNEL);
> =C2=A0
> =C2=A0	if (!instance->cmd_list) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "out of
> memory\n");
> +		dev_dbg(&instance->pdev->dev, "out of memory\n");
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> =C2=A0
> @@ -3746,7 +3746,7 @@ int megasas_alloc_cmds(struct megasas_instance
> *instance)
> =C2=A0	=C2=A0* Create a frame pool and assign one frame to each cmd
> =C2=A0	=C2=A0*/
> =C2=A0	if (megasas_create_frame_pool(instance)) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error
> creating frame DMA pool\n");
> +		dev_dbg(&instance->pdev->dev, "Error creating frame
> DMA pool\n");
> =C2=A0		megasas_free_cmds(instance);
> =C2=A0	}
> =C2=A0
> @@ -3775,7 +3775,7 @@ megasas_get_pd_list(struct megasas_instance
> *instance)
> =C2=A0	cmd =3D megasas_get_cmd(instance);
> =C2=A0
> =C2=A0	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev,
> "(get_pd_list): Failed to get cmd\n");
> +		dev_dbg(&instance->pdev->dev, "(get_pd_list): Failed
> to get cmd\n");
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> =C2=A0
> @@ -3785,7 +3785,7 @@ megasas_get_pd_list(struct megasas_instance
> *instance)
> =C2=A0		=C2=A0=C2=A0MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST),
> &ci_h);
> =C2=A0
> =C2=A0	if (!ci) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed
> to alloc mem for pd_list\n");
> +		dev_dbg(&instance->pdev->dev, "Failed to alloc mem
> for pd_list\n");
> =C2=A0		megasas_return_cmd(instance, cmd);
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> @@ -3870,7 +3870,7 @@ megasas_get_ld_list(struct megasas_instance
> *instance)
> =C2=A0	cmd =3D megasas_get_cmd(instance);
> =C2=A0
> =C2=A0	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev,
> "megasas_get_ld_list: Failed to get cmd\n");
> +		dev_dbg(&instance->pdev->dev, "megasas_get_ld_list:
> Failed to get cmd\n");
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> =C2=A0
> @@ -3881,7 +3881,7 @@ megasas_get_ld_list(struct megasas_instance
> *instance)
> =C2=A0				&ci_h);
> =C2=A0
> =C2=A0	if (!ci) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed
> to alloc mem in get_ld_list\n");
> +		dev_dbg(&instance->pdev->dev, "Failed to alloc mem
> in get_ld_list\n");
> =C2=A0		megasas_return_cmd(instance, cmd);
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> @@ -4094,7 +4094,7 @@ megasas_get_ctrl_info(struct megasas_instance
> *instance)
> =C2=A0	cmd =3D megasas_get_cmd(instance);
> =C2=A0
> =C2=A0	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed
> to get a free cmd\n");
> +		dev_dbg(&instance->pdev->dev, "Failed to get a free
> cmd\n");
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> =C2=A0
> @@ -4104,7 +4104,7 @@ megasas_get_ctrl_info(struct megasas_instance
> *instance)
> =C2=A0				=C2=A0=C2=A0sizeof(struct megasas_ctrl_info),
> &ci_h);
> =C2=A0
> =C2=A0	if (!ci) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed
> to alloc mem for ctrl info\n");
> +		dev_dbg(&instance->pdev->dev, "Failed to alloc mem
> for ctrl info\n");
> =C2=A0		megasas_return_cmd(instance, cmd);
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> @@ -4341,7 +4341,7 @@ megasas_init_adapter_mfi(struct
> megasas_instance *instance)
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&instance-
> >reply_queue_h);
> =C2=A0
> =C2=A0	if (!instance->reply_queue) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Out of
> DMA mem for reply queue\n");
> +		dev_dbg(&instance->pdev->dev, "Out of DMA mem for
> reply queue\n");
> =C2=A0		goto fail_reply_queue;
> =C2=A0	}
> =C2=A0
> @@ -4504,7 +4504,7 @@ static int megasas_init_fw(struct
> megasas_instance *instance)
> =C2=A0	instance->bar =3D find_first_bit(&bar_list, sizeof(unsigned
> long));
> =C2=A0	if (pci_request_selected_regions(instance->pdev, instance-
> >bar,
> =C2=A0					=C2=A0"megasas: LSI")) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "IO
> memory region busy!\n");
> +		dev_dbg(&instance->pdev->dev, "IO memory region
> busy!\n");
> =C2=A0		return -EBUSY;
> =C2=A0	}
> =C2=A0
> @@ -4512,7 +4512,7 @@ static int megasas_init_fw(struct
> megasas_instance *instance)
> =C2=A0	instance->reg_set =3D ioremap_nocache(base_addr, 8192);
> =C2=A0
> =C2=A0	if (!instance->reg_set) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed
> to map IO mem\n");
> +		dev_dbg(&instance->pdev->dev, "Failed to map IO
> mem\n");
> =C2=A0		goto fail_ioremap;
> =C2=A0	}
> =C2=A0
> @@ -4958,7 +4958,7 @@ megasas_register_aen(struct megasas_instance
> *instance, u32 seq_num,
> =C2=A0								=C2=A0=C2=A0ae
> n_cmd, 30);
> =C2=A0
> =C2=A0			if (ret_val) {
> -				dev_printk(KERN_DEBUG, &instance-
> >pdev->dev, "Failed to abort "
> +				dev_dbg(&instance->pdev->dev,
> "Failed to abort "
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"previous AEN com=
mand\n");
> =C2=A0				return ret_val;
> =C2=A0			}
> @@ -5204,7 +5204,7 @@ static int megasas_probe_one(struct pci_dev
> *pdev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(struct mega=
sas_instance));
> =C2=A0
> =C2=A0	if (!host) {
> -		dev_printk(KERN_DEBUG, &pdev->dev, "scsi_host_alloc
> failed\n");
> +		dev_dbg(&pdev->dev, "scsi_host_alloc failed\n");
> =C2=A0		goto fail_alloc_instance;
> =C2=A0	}
> =C2=A0
> @@ -5224,7 +5224,7 @@ static int megasas_probe_one(struct pci_dev
> *pdev,
> =C2=A0		instance->ctrl_context =3D (void
> *)__get_free_pages(GFP_KERNEL,
> =C2=A0				instance->ctrl_context_pages);
> =C2=A0		if (!instance->ctrl_context) {
> -			dev_printk(KERN_DEBUG, &pdev->dev, "Failed
> to allocate "
> +			dev_dbg(&pdev->dev, "Failed to allocate "
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"memory for Fusion=
 context info\n");
> =C2=A0			goto fail_alloc_dma_buf;
> =C2=A0		}
> @@ -5243,7 +5243,7 @@ static int megasas_probe_one(struct pci_dev
> *pdev,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&instance->consumer_h);
> =C2=A0
> =C2=A0		if (!instance->producer || !instance->consumer) {
> -			dev_printk(KERN_DEBUG, &pdev->dev, "Failed
> to allocate"
> +			dev_dbg(&pdev->dev, "Failed to allocate"
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"memory for produc=
er, consumer\n");
> =C2=A0			goto fail_alloc_dma_buf;
> =C2=A0		}
> @@ -5290,7 +5290,7 @@ static int megasas_probe_one(struct pci_dev
> *pdev,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0&instance-
> >evt_detail_h);
> =C2=A0
> =C2=A0	if (!instance->evt_detail) {
> -		dev_printk(KERN_DEBUG, &pdev->dev, "Failed to
> allocate memory for "
> +		dev_dbg(&pdev->dev, "Failed to allocate memory for "
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"event detail struc=
ture\n");
> =C2=A0		goto fail_alloc_dma_buf;
> =C2=A0	}
> @@ -5397,7 +5397,7 @@ static int megasas_probe_one(struct pci_dev
> *pdev,
> =C2=A0	=C2=A0* Initiate AEN (Asynchronous Event Notification)
> =C2=A0	=C2=A0*/
> =C2=A0	if (megasas_start_aen(instance)) {
> -		dev_printk(KERN_DEBUG, &pdev->dev, "start aen
> failed\n");
> +		dev_dbg(&pdev->dev, "start aen failed\n");
> =C2=A0		goto fail_start_aen;
> =C2=A0	}
> =C2=A0
> @@ -5973,14 +5973,14 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
> *instance,
> =C2=A0	memset(kbuff_arr, 0, sizeof(kbuff_arr));
> =C2=A0
> =C2=A0	if (ioc->sge_count > MAX_IOCTL_SGE) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "SGE
> count [%d] >=C2=A0=C2=A0max limit [%d]\n",
> +		dev_dbg(&instance->pdev->dev, "SGE count [%d] >=C2=A0=C2=A0max
> limit [%d]\n",
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ioc->sge_count, MAX=
_IOCTL_SGE);
> =C2=A0		return -EINVAL;
> =C2=A0	}
> =C2=A0
> =C2=A0	cmd =3D megasas_get_cmd(instance);
> =C2=A0	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed
> to get a cmd packet\n");
> +		dev_dbg(&instance->pdev->dev, "Failed to get a cmd
> packet\n");
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> =C2=A0
> @@ -6025,7 +6025,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
> *instance,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0ioc-
> >sgl[i].iov_len,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0&buf_handle,
> GFP_KERNEL);
> =C2=A0		if (!kbuff_arr[i]) {
> -			dev_printk(KERN_DEBUG, &instance->pdev->dev,=20
> "Failed to alloc "
> +			dev_dbg(&instance->pdev->dev, "Failed to
> alloc "
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"kernel SGL buffer=
 for IOCTL\n");
> =C2=A0			error =3D -ENOMEM;
> =C2=A0			goto out;
> @@ -6111,7 +6111,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
> *instance,
> =C2=A0	=C2=A0*/
> =C2=A0	if (copy_to_user(&user_ioc->frame.hdr.cmd_status,
> =C2=A0			=C2=A0&cmd->frame->hdr.cmd_status, sizeof(u8))) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error
> copying out cmd_status\n");
> +		dev_dbg(&instance->pdev->dev, "Error copying out
> cmd_status\n");
> =C2=A0		error =3D -EFAULT;
> =C2=A0	}
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
