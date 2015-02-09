From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen-scsiback: some modifications about code comment
Date: Mon, 09 Feb 2015 08:08:21 +0100
Message-ID: <54D85CE5.2040404@suse.com>
References: <1423279877-8048-1-git-send-email-rudy.zhangmin@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423279877-8048-1-git-send-email-rudy.zhangmin@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rudy Zhang <rudy.zhangmin@huawei.com>, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, boby.chen@huawei.com, wu.wubin@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 02/07/2015 04:31 AM, Rudy Zhang wrote:
> From: Tao Chen <boby.chen@huawei.com>
>
> Signed-off-by: Tao Chen <boby.chen@huawei.com>

Are some white space fixes in comments really worth a patch?

Juergen

> ---
>   drivers/xen/xen-scsiback.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index 3e32146..59f09fd 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -83,7 +83,7 @@ struct ids_tuple {
>
>   struct v2p_entry {
>   	struct ids_tuple v;		/* translate from */
> -	struct scsiback_tpg *tpg;	/* translate to   */
> +	struct scsiback_tpg *tpg;	/* translate to */
>   	unsigned int lun;
>   	struct kref kref;
>   	struct list_head l;
> @@ -525,7 +525,7 @@ static int scsiback_gnttab_data_map(struct vscsiif_request *ring_req,
>   		}
>   	}
>
> -	/* free of (sgl) in fast_flush_area()*/
> +	/* free of (sgl) in fast_flush_area() */
>   	pending_req->sgl = kmalloc_array(nr_segments,
>   					sizeof(struct scatterlist), GFP_KERNEL);
>   	if (!pending_req->sgl)
> @@ -1084,7 +1084,7 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
>   			}
>   		}
>   		break;
> -	/*When it is necessary, processing is added here.*/
> +	/* When it is necessary, processing is added here. */
>   	default:
>   		break;
>   	}
> @@ -1475,8 +1475,8 @@ static u32 scsiback_tpg_get_inst_index(struct se_portal_group *se_tpg)
>   static int scsiback_check_stop_free(struct se_cmd *se_cmd)
>   {
>   	/*
> -	 * Do not release struct se_cmd's containing a valid TMR
> -	 * pointer.  These will be released directly in scsiback_device_action()
> +	 * Do not release struct se_cmd's containing a valid TMR pointer.
> +	 * These will be released directly in scsiback_device_action()
>   	 * with transport_generic_free_cmd().
>   	 */
>   	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> @@ -1642,7 +1642,7 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
>   		return -ENOMEM;
>   	}
>   	/*
> -	 *  Initialize the struct se_session pointer
> +	 * Initialize the struct se_session pointer
>   	 */
>   	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_NORMAL);
>   	if (IS_ERR(tv_nexus->tvn_se_sess)) {
> @@ -1759,7 +1759,7 @@ static ssize_t scsiback_tpg_store_nexus(struct se_portal_group *se_tpg,
>   	unsigned char i_port[VSCSI_NAMELEN], *ptr, *port_ptr;
>   	int ret;
>   	/*
> -	 * Shutdown the active I_T nexus if 'NULL' is passed..
> +	 * Shutdown the active I_T nexus if 'NULL' is passed.
>   	 */
>   	if (!strncmp(page, "NULL", 4)) {
>   		ret = scsiback_drop_nexus(tpg);
> @@ -1930,7 +1930,7 @@ static void scsiback_drop_tpg(struct se_portal_group *se_tpg)
>   	 */
>   	scsiback_drop_nexus(tpg);
>   	/*
> -	 * Deregister the se_tpg from TCM..
> +	 * Deregister the se_tpg from TCM.
>   	 */
>   	core_tpg_deregister(se_tpg);
>   	kfree(tpg);
>
