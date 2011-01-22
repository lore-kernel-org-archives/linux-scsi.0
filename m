From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target_core_mib.h move
Date: Sat, 22 Jan 2011 15:19:07 -0800
Message-ID: <1295738347.24778.21.camel@haakon2.linux-iscsi.org>
References: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
	 <20110117205130.GA22532@infradead.org>
	 <AANLkTinNiohS+9WDcCP4P=0beRRE53x4iFC9u7iXBOy2@mail.gmail.com>
	 <1295381563.22813.429.camel@haakon2.linux-iscsi.org>
	 <1295384544.22813.446.camel@haakon2.linux-iscsi.org>
	 <AANLkTikQHPQT0V2tNUZDsiWoE6NHH9YWA9x6gfvu6nYE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41463 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1AVXTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jan 2011 18:19:25 -0500
In-Reply-To: <AANLkTikQHPQT0V2tNUZDsiWoE6NHH9YWA9x6gfvu6nYE@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2011-01-22 at 15:49 +0100, Fubo Chen wrote:
> On Tue, Jan 18, 2011 at 10:02 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > Hi again Fubo,
> >
> > If you want to re-generate your driver, please make sure to grab the
> > patch for tcm_mod_builder.py merged into lio-core-2.6.git that
> > uses /Makefile instead of /Kbuild filenames here:
> >
> > target: Convert tcm_mod_builder.py from Kbuild -> Makefile
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=3103722a1cf759d475b9ecd9cdb0df523dbf09ab
> >
> > Thanks!
> >
> > --nab
> 
> Thank You for all help !!
> 
> But why sparse confused ? I get this:
> 
> $ make C=2 M=drivers/target modules
>   CHECK   drivers/target/target_core_configfs.c
> drivers/target/target_core_configfs.c:3131:54: warning: Using plain
> integer as NULL pointer
> drivers/target/target_core_configfs.c:3145:50: warning: Using plain
> integer as NULL pointer
> drivers/target/target_core_configfs.c:3212:42: warning: Using plain
> integer as NULL pointer
>   CC [M]  drivers/target/target_core_configfs.o
>   CHECK   drivers/target/target_core_device.c
> drivers/target/target_core_device.c:354:5: warning: context imbalance
> in 'core_update_device_list_for_node' - wrong count at exit
> drivers/target/target_core_device.c:590:13: warning: context imbalance
> in 'core_release_port' - unexpected unlock
> drivers/target/target_core_device.c:800:36: warning: context imbalance
> in 'se_clear_dev_ports' - unexpected unlock
>   CC [M]  drivers/target/target_core_device.o
>   CHECK   drivers/target/target_core_fabric_configfs.c
>   CC [M]  drivers/target/target_core_fabric_configfs.o
>   CHECK   drivers/target/target_core_fabric_lib.c
> drivers/target/target_core_fabric_lib.c:47:4: warning: symbol
> 'sas_get_fabric_proto_ident' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:57:5: warning: symbol
> 'sas_get_pr_transport_id' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:88:5: warning: symbol
> 'sas_get_pr_transport_id_len' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:109:6: warning: symbol
> 'sas_parse_pr_out_transport_id' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:133:4: warning: symbol
> 'fc_get_fabric_proto_ident' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:139:5: warning: symbol
> 'fc_get_pr_transport_id_len' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:153:5: warning: symbol
> 'fc_get_pr_transport_id' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:190:6: warning: symbol
> 'fc_parse_pr_out_transport_id' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:212:4: warning: symbol
> 'iscsi_get_fabric_proto_ident' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:222:5: warning: symbol
> 'iscsi_get_pr_transport_id' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:318:5: warning: symbol
> 'iscsi_get_pr_transport_id_len' was not declared. Should it be static?
> drivers/target/target_core_fabric_lib.c:364:6: warning: symbol
> 'iscsi_parse_pr_out_transport_id' was not declared. Should it be
> static?
>   CC [M]  drivers/target/target_core_fabric_lib.o
>   CHECK   drivers/target/target_core_hba.c
>   CC [M]  drivers/target/target_core_hba.o
>   CHECK   drivers/target/target_core_pr.c
> drivers/target/target_core_pr.c:2003:25: warning: incorrect type in
> assignment (different address spaces)
> drivers/target/target_core_pr.c:2003:25:    expected void [noderef]
> <asn:1>*iov_base
> drivers/target/target_core_pr.c:2003:25:    got unsigned char *
> drivers/target/target_core_pr.c:2011:36: warning: incorrect type in
> argument 2 (different address spaces)
> drivers/target/target_core_pr.c:2011:36:    expected struct iovec
> const [noderef] <asn:1>*<noident>
> drivers/target/target_core_pr.c:2011:36:    got struct iovec *
>   CC [M]  drivers/target/target_core_pr.o
>   CHECK   drivers/target/target_core_alua.c
> drivers/target/target_core_alua.c:647:25: warning: incorrect type in
> assignment (different address spaces)
> drivers/target/target_core_alua.c:647:25:    expected void [noderef]
> <asn:1>*iov_base
> drivers/target/target_core_alua.c:647:25:    got unsigned char *
> drivers/target/target_core_alua.c:652:36: warning: incorrect type in
> argument 2 (different address spaces)
> drivers/target/target_core_alua.c:652:36:    expected struct iovec
> const [noderef] <asn:1>*<noident>
> drivers/target/target_core_alua.c:652:36:    got struct iovec *
>   CC [M]  drivers/target/target_core_alua.o
>   CHECK   drivers/target/target_core_scdb.c
>   CC [M]  drivers/target/target_core_scdb.o
>   CHECK   drivers/target/target_core_tmr.c
>   CC [M]  drivers/target/target_core_tmr.o
>   CHECK   drivers/target/target_core_tpg.c
>   CC [M]  drivers/target/target_core_tpg.o
>   CHECK   drivers/target/target_core_transport.c
> drivers/target/target_core_transport.c:4373:12: warning: function
> 'transport_calc_sg_num' with external linkage has definition
> drivers/target/target_core_transport.c:194:19: warning: symbol
> 'se_mem_cache' was not declared. Should it be static?
>   CC [M]  drivers/target/target_core_transport.o
>   CHECK   drivers/target/target_core_cdb.c
> drivers/target/target_core_cdb.c:1030:1: warning: symbol
> 'transport_emulate_control_cdb' was not declared. Should it be static?
>   CC [M]  drivers/target/target_core_cdb.o
>   CHECK   drivers/target/target_core_ua.c
>   CC [M]  drivers/target/target_core_ua.o
>   CHECK   drivers/target/target_core_rd.c
>   CC [M]  drivers/target/target_core_rd.o
>   CHECK   drivers/target/target_core_mib.c
> drivers/target/target_core_mib.c:70:13: warning: context imbalance in
> 'locate_hba_start' - wrong count at exit
> drivers/target/target_core_mib.c:86:13: warning: context imbalance in
> 'locate_hba_stop' - unexpected unlock
> drivers/target/target_core_mib.c:98:13: warning: context imbalance in
> 'scsi_inst_seq_start' - wrong count at exit
> drivers/target/target_core_mib.c:114:13: warning: context imbalance in
> 'scsi_inst_seq_stop' - unexpected unlock
> drivers/target/target_core_mib.c:577:13: warning: context imbalance in
> 'scsi_auth_intr_seq_start' - wrong count at exit
> drivers/target/target_core_mib.c:589:13: warning: context imbalance in
> 'scsi_auth_intr_seq_stop' - unexpected unlock
> drivers/target/target_core_mib.c:702:13: warning: context imbalance in
> 'scsi_att_intr_port_seq_start' - wrong count at exit
> drivers/target/target_core_mib.c:714:13: warning: context imbalance in
> 'scsi_att_intr_port_seq_stop' - unexpected unlock
>   CC [M]  drivers/target/target_core_mib.o
>   LD [M]  drivers/target/target_core_mod.o
>   CHECK   drivers/target/target_core_iblock.c
> drivers/target/target_core_iblock.c:136:24: warning: Using plain
> integer as NULL pointer
> drivers/target/target_core_iblock.c:145:24: warning: Using plain
> integer as NULL pointer
>   CC [M]  drivers/target/target_core_iblock.o
>   CHECK   drivers/target/target_core_file.c
> drivers/target/target_core_file.c:144:25: warning: incorrect type in
> argument 1 (different address spaces)
> drivers/target/target_core_file.c:144:25:    expected char const
> [noderef] <asn:1>*<noident>
> drivers/target/target_core_file.c:144:25:    got unsigned char *<noident>
> drivers/target/target_core_file.c:304:33: warning: incorrect type in
> assignment (different address spaces)
> drivers/target/target_core_file.c:304:33:    expected void [noderef]
> <asn:1>*iov_base
> drivers/target/target_core_file.c:304:33:    got void *
> drivers/target/target_core_file.c:309:33: warning: incorrect type in
> argument 2 (different address spaces)
> drivers/target/target_core_file.c:309:33:    expected struct iovec
> const [noderef] <asn:1>*<noident>
> drivers/target/target_core_file.c:309:33:    got struct iovec *
> drivers/target/target_core_file.c:354:33: warning: incorrect type in
> assignment (different address spaces)
> drivers/target/target_core_file.c:354:33:    expected void [noderef]
> <asn:1>*iov_base
> drivers/target/target_core_file.c:354:33:    got void *
> drivers/target/target_core_file.c:359:34: warning: incorrect type in
> argument 2 (different address spaces)
> drivers/target/target_core_file.c:359:34:    expected struct iovec
> const [noderef] <asn:1>*<noident>
> drivers/target/target_core_file.c:359:34:    got struct iovec *
>   CC [M]  drivers/target/target_core_file.o
>   CHECK   drivers/target/target_core_pscsi.c
> drivers/target/target_core_pscsi.c:453:17: warning: context imbalance
> in 'pscsi_create_type_disk' - unexpected unlock
> drivers/target/target_core_pscsi.c:499:17: warning: context imbalance
> in 'pscsi_create_type_rom' - unexpected unlock
> drivers/target/target_core_pscsi.c:521:25: warning: context imbalance
> in 'pscsi_create_type_other' - unexpected unlock
> drivers/target/target_core_pscsi.c:544:25: warning: context imbalance
> in 'pscsi_create_virtdevice' - different lock contexts for basic block
>   CC [M]  drivers/target/target_core_pscsi.o
>   Building modules, stage 2.
>   MODPOST 4 modules
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   CC      drivers/target/target_core_file.mod.o
>   LD [M]  drivers/target/target_core_file.ko
>   CC      drivers/target/target_core_iblock.mod.o
>   LD [M]  drivers/target/target_core_iblock.ko
>   LD [M]  drivers/target/target_core_mod.ko
>   CC      drivers/target/target_core_pscsi.mod.o
>   LD [M]  drivers/target/target_core_pscsi.ko
> 
> 
> 

Hi Fubo,

The patch to convert 'int var:1' to 'bool var:1' in target_core_base.h
and fix one of the specific sparse warning was commited from Dan
Carpenter into linus-38-rc1:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=daf0bd7aa57e14b903c81761b421e1130f12b7d1

While most of the other sparse warnings above appear to be false
positives AFAICT, there are additional two patches that have been pushed
into the new lio-core-2.6.git/linus-38-rc2, and will be hitting the list
shortly.

Thanks for your head-ups on the sparse fixes, and please let us know if
you see any other items that need to be considered.

Best Regards,

--nab

> 
> My patch:
> 
> diff --git a/include/target/target_core_base.h
> b/include/target/target_core_base.h
> index 07fdfb6..4139bf0 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -225,7 +225,7 @@ struct t10_alua_lu_gp {
>  } ____cacheline_aligned;
> 
>  struct t10_alua_lu_gp_member {
> -	int lu_gp_assoc:1;
> +	int lu_gp_assoc;
>  	atomic_t lu_gp_mem_ref_cnt;
>  	spinlock_t lu_gp_mem_lock;
>  	struct t10_alua_lu_gp *lu_gp;
> @@ -257,7 +257,7 @@ struct t10_alua_tg_pt_gp {
>  } ____cacheline_aligned;
> 
>  struct t10_alua_tg_pt_gp_member {
> -	int tg_pt_gp_assoc:1;
> +	int tg_pt_gp_assoc;
>  	atomic_t tg_pt_gp_mem_ref_cnt;
>  	spinlock_t tg_pt_gp_mem_lock;
>  	struct t10_alua_tg_pt_gp *tg_pt_gp;
> @@ -322,7 +322,7 @@ struct t10_pr_registration {
>  	int pr_res_type;
>  	int pr_res_scope;
>  	/* Used for fabric initiator WWPNs using a ISID */
> -	int isid_present_at_reg:1;
> +	int isid_present_at_reg;
>  	u32 pr_res_mapped_lun;
>  	u32 pr_aptpl_target_lun;
>  	u32 pr_res_generation;
> @@ -404,7 +404,7 @@ struct se_transport_task {
>  	unsigned long long	t_task_lba;
>  	int			t_tasks_failed;
>  	int			t_tasks_fua;
> -	int			t_tasks_bidi:1;
> +	int			t_tasks_bidi;
>  	u32			t_task_cdbs;
>  	u32			t_tasks_check;
>  	u32			t_tasks_no;
> @@ -456,7 +456,7 @@ struct se_task {
>  	u8		task_flags;
>  	int		task_error_status;
>  	int		task_state_flags;
> -	int		task_padded_sg:1;
> +	int		task_padded_sg;
>  	unsigned long long	task_lba;
>  	u32		task_no;
>  	u32		task_sectors;
> @@ -569,7 +569,7 @@ struct se_ua {
>  struct se_node_acl {
>  	char			initiatorname[TRANSPORT_IQN_LEN];
>  	/* Used to signal demo mode created ACL, disabled by default */
> -	int			dynamic_node_acl:1;
> +	int			dynamic_node_acl;
>  	u32			queue_depth;
>  	u32			acl_index;
>  	u64			num_cmds;
> @@ -622,7 +622,7 @@ struct se_lun_acl {
>  }  ____cacheline_aligned;
> 
>  struct se_dev_entry {
> -	int			def_pr_registered:1;
> +	int			def_pr_registered;
>  	/* See transport_lunflags_table */
>  	u32			lun_flags;
>  	u32			deve_cmds;
> diff --git a/include/target/target_core_fabric_ops.h
> b/include/target/target_core_fabric_ops.h
> index f3ac12b..997c45f 100644
> --- a/include/target/target_core_fabric_ops.h
> +++ b/include/target/target_core_fabric_ops.h
> @@ -8,7 +8,7 @@ struct target_core_fabric_ops {
>  	 * for scatterlist chaining using transport_do_task_sg_link(),
>  	 * disabled by default
>  	 */
> -	int task_sg_chaining:1;
> +	int task_sg_chaining;
>  	char *(*get_fabric_name)(void);
>  	u8 (*get_fabric_proto_ident)(struct se_portal_group *);
>  	char *(*tpg_get_wwn)(struct se_portal_group *);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

