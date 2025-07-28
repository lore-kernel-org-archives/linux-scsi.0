Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E391C5D57;
	Mon, 28 Jul 2025 15:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753715700; cv=none; b=oI4dkszYds7CSHfFHPVU5PO67nnPYKWfbKgJucSrwULof7JQQdKE5v36pqTHjwAekx0J0NOKYgSmJlD2VIiN1cXl1/TCFWyRzIIIx51qBAM3j3Y6eawkOfhyfCdUepIKy3uLhiTFvmdTbOD7tbzIrhMKKg/smlpL8O3Uc/AmlBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753715700; c=relaxed/simple;
	bh=LUSOZzhxd9H1V9irgfOBLM74H+BWFhbD6Y6hZjZAzb8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJcfI10vtUVUk7uhqN6et26k3YlIwgszR6arJXcL82h4KvQrbYncK7DSXpOgrzuqJ012TgObBM+thT3yYuWo8FiaDo4HvfQWiPXoliRPDe0B/BVV/BJ63JGGqhyL1bgetPIL19Lt59pDelsID+Aw93B6qCnVr3EvI0VaUlQZFxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=F3wfv2SS; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=ZQRrHc/x; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="F3wfv2SS";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="ZQRrHc/x"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id BD0F0E000A;
	Mon, 28 Jul 2025 18:08:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com BD0F0E000A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1753715301; bh=c4mNqgbRrsLkUilozhV4A/8DoaHB7s3V/OCJXE6f070=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=F3wfv2SSOVM8DSMPhQLTBha6U7NTZ13DycR6UAbatbFPjWZye7RmeSuvekmajg2J3
	 R0Jrlw4ouwk48WT/nWVDD+ccJBf/VilPgqqUzEi25peGy1uZirvlvD3DletP9qIUNt
	 /Nv/ygbeyAS3rLLa8ACt7zzt9Ewu/VwZhtHICmoeHYFBBMIYBtpLB9IfXXzDRbEzvb
	 BH/imnt5hOBFVlqkb4JMC47v6WvujEwcOUAv+h91RY+5s/YzJ/PmBKWqY7Rqn8mfR2
	 YwSqKFHTS/excESXKONcvdyTGqMdlubCTUBBlXJgRSzqPbGK0TAo1YDG9zRi2yA5it
	 6RFQOD5Ghe4nQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1753715301; bh=c4mNqgbRrsLkUilozhV4A/8DoaHB7s3V/OCJXE6f070=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=ZQRrHc/xLoOvIOMoPffSnfyMCWjWSpdpQjknwySZij7opse5vZ/yFeTnEfzWj7DED
	 0+hq73kw0MTNqM57TsHaV5326g/4sc2zHcSThcXcZHVCUrKFLbp5yxgB1/4obxp9Za
	 4+8bG6fEA/k4G/8j0Cl6pg1RHWeb1WzSQUXvTG51rhdtaKsvNKy8eg+Ru43nJo54eJ
	 bL/O3MudHEZtrFy5ldU1mhQ0daPl0ecxl1DaJQT+jVtAdhHeRjyO83zPBOoPCcvSVS
	 9zzMjNkE3x2PisjqM32DetYMVgsC2vUSsVtihhe5KAUYawG5xg5H4eHfK6dDPAVlEk
	 6TBgUm//AUD4A==
Received: from T-EXCH-07.corp.yadro.com (T-EXCH-07.corp.yadro.com [172.17.11.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Mon, 28 Jul 2025 18:08:20 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (172.17.11.143) by
 T-EXCH-07.corp.yadro.com (172.17.11.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 28 Jul 2025 18:08:20 +0300
Received: from yadro.com (172.17.34.55) by T-EXCH-12.corp.yadro.com
 (172.17.11.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 28 Jul
 2025 18:08:08 +0300
Date: Mon, 28 Jul 2025 18:08:33 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Mike Christie <michael.christie@oracle.com>
CC: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: target: Move LUN stats to per CPU
Message-ID: <20250728150833.GB12562@yadro.com>
References: <20250724004558.40993-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250724004558.40993-1-michael.christie@oracle.com>
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 T-EXCH-12.corp.yadro.com (172.17.11.143)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/07/28 10:15:00 #27643540
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Wed, Jul 23, 2025 at 07:45:57PM -0500, Mike Christie wrote:
> The atomic use in the main I/O path is causing perf issues when using
> higher performance backend devices and multiple queues. This moves the
> LUN stats to per CPU.
> 
> I forgot to include this patch with the delayed/ordered per CPU
> tracking and per device/device entry per CPU stats. With this patch
> you get the full 33% improvements when using fast backends, multiple
> queues and multiple IO submiters.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_fabric_configfs.c |  2 +-
>  drivers/target/target_core_internal.h        |  1 +
>  drivers/target/target_core_stat.c            | 48 ++++++++++++++++----
>  drivers/target/target_core_tpg.c             | 21 +++++++++
>  drivers/target/target_core_transport.c       | 14 +++---
>  include/target/target_core_base.h            |  8 ++--
>  6 files changed, 73 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 7156a4dc1ca7..13159928e365 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -697,7 +697,7 @@ static void target_fabric_port_release(struct config_item *item)
>         struct se_lun *lun = container_of(to_config_group(item),
>                                           struct se_lun, lun_group);
> 
> -       kfree_rcu(lun, rcu_head);
> +       call_rcu(&lun->rcu_head, target_tpg_free_lun);

There is se_tpg->tpg_virt_lun0 that is also the lun object that will
have allocated lun_stats, but tpg_virt_lun0 is deallocated in other
places. You have to take care of it to not leak its lun_stats.

>  }
> 
>  static struct configfs_item_operations target_fabric_port_item_ops = {
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 408be26d2e9b..dfe529e59a29 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -125,6 +125,7 @@ void        core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *,
>                                   struct se_lun *);
>  void   core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
>  struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u64);
> +void   target_tpg_free_lun(struct rcu_head *head);
>  int    core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
>                 bool, struct se_device *);
>  void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index 6bdf2d8bd694..88f8be197a68 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -627,14 +627,24 @@ static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *item,
>                 char *page)
>  {
>         struct se_lun *lun = to_stat_tgt_port(item);
> +       struct scsi_port_stats *stats;
>         struct se_device *dev;
>         ssize_t ret = -ENODEV;
> +       unsigned int cpu;
> +       u32 pdus = 0;
> 
>         rcu_read_lock();
>         dev = rcu_dereference(lun->lun_se_dev);
> -       if (dev)
> -               ret = snprintf(page, PAGE_SIZE, "%lu\n",
> -                              atomic_long_read(&lun->lun_stats.cmd_pdus));
> +       if (!dev)
> +               goto unlock;
> +
> +       for_each_possible_cpu(cpu) {
> +               stats = per_cpu_ptr(lun->lun_stats, cpu);
> +               pdus += stats->cmd_pdus;
> +       }
> +
> +       ret = snprintf(page, PAGE_SIZE, "%u\n", pdus);
> +unlock:
>         rcu_read_unlock();
>         return ret;
>  }
> @@ -643,14 +653,24 @@ static ssize_t target_stat_tgt_port_write_mbytes_show(struct config_item *item,
>                 char *page)
>  {
>         struct se_lun *lun = to_stat_tgt_port(item);
> +       struct scsi_port_stats *stats;
>         struct se_device *dev;
>         ssize_t ret = -ENODEV;
> +       unsigned int cpu;
> +       u32 octets = 0;
> 
>         rcu_read_lock();
>         dev = rcu_dereference(lun->lun_se_dev);
> -       if (dev)
> -               ret = snprintf(page, PAGE_SIZE, "%u\n",
> -                       (u32)(atomic_long_read(&lun->lun_stats.rx_data_octets) >> 20));
> +       if (!dev)
> +               goto unlock;
> +
> +       for_each_possible_cpu(cpu) {
> +               stats = per_cpu_ptr(lun->lun_stats, cpu);
> +               octets += stats->rx_data_octets;
> +       }
> +
> +       ret = snprintf(page, PAGE_SIZE, "%u\n", octets);
> +unlock:
>         rcu_read_unlock();
>         return ret;
>  }
> @@ -659,14 +679,24 @@ static ssize_t target_stat_tgt_port_read_mbytes_show(struct config_item *item,
>                 char *page)
>  {
>         struct se_lun *lun = to_stat_tgt_port(item);
> +       struct scsi_port_stats *stats;
>         struct se_device *dev;
>         ssize_t ret = -ENODEV;
> +       unsigned int cpu;
> +       u32 octets = 0;
> 
>         rcu_read_lock();
>         dev = rcu_dereference(lun->lun_se_dev);
> -       if (dev)
> -               ret = snprintf(page, PAGE_SIZE, "%u\n",
> -                               (u32)(atomic_long_read(&lun->lun_stats.tx_data_octets) >> 20));
> +       if (!dev)
> +               goto unlock;
> +
> +       for_each_possible_cpu(cpu) {
> +               stats = per_cpu_ptr(lun->lun_stats, cpu);
> +               octets += stats->tx_data_octets;
> +       }
> +
> +       ret = snprintf(page, PAGE_SIZE, "%u\n", octets);
> +unlock:
>         rcu_read_unlock();
>         return ret;
>  }

May be that is a time to refactor this file using macro magic?
Something like:

static u64 _target_stat_get_u64_luns_stats(struct se_lun *lun, u64 offset)
{
	int cpu;
	u64 res = 0;
	u8 *stats;

	for_each_possible_cpu(cpu) {
		const struct scsi_port_stats *pcpu_stats;

		pcpu_stats = per_cpu_ptr(lun->lun_stats, cpu);
		stats = (u8 *)pcpu_stats;
		res += *(u64 *)(stats + offset);
	}

	return res;
}
#define target_stat_get_u64_luns_stats(LUN, FIELD)			\
	_target_stat_get_u64_luns_stats(LUN,				\
					offsetof(struct scsi_port_stats, FIELD))

#define _SYSFS_TGT_PORT_STATS_U64_SHOW(STAT, VAR, LAMBDA)		\
static ssize_t target_stat_tgt_port_##STAT##_show(			\
					struct config_item *item,	\
					char *page)			\
{									\
	struct se_lun *lun = to_stat_tgt_port(item);			\
	struct se_device *dev;						\
	ssize_t ret = -ENODEV;						\
	u64 VAR;							\
									\
	rcu_read_lock();						\
	dev = rcu_dereference(lun->lun_se_dev);				\
	if (dev) {							\
		VAR = target_stat_get_u64_luns_stats(lun, VAR);		\
		VAR = LAMBDA(VAR);					\
		ret = snprintf(page, PAGE_SIZE, "%llu\n", VAR);		\
	}								\
	rcu_read_unlock();						\
	return ret;							\
}

#define LAMBDA_NOOP(A) (A)
#define LAMBDA_MBYTES(A) (A >> 20)
#define SYSFS_TGT_PORT_STATS_U64_SHOW(STAT, VAR)			\
	_SYSFS_TGT_PORT_STATS_U64_SHOW(STAT, VAR, LAMBDA_NOOP)
#define SYSFS_TGT_PORT_STATS_U64_SHOW_MBYTES(STAT, VAR)			\
	_SYSFS_TGT_PORT_STATS_U64_SHOW(STAT, VAR, LAMBDA_MBYTES)


SYSFS_TGT_PORT_STATS_U64_SHOW(in_cmds, cmd_pdus)
SYSFS_TGT_PORT_STATS_U64_SHOW(in_cmds, hs_cmd_pdus)
SYSFS_TGT_PORT_STATS_U64_SHOW_MBYTES(write_mbytes, rx_data_octets)
SYSFS_TGT_PORT_STATS_U64_SHOW_MBYTES(read_mbytes, tx_data_octets)


> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index c0e429e5ef31..caa95aa6f502 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -609,12 +609,21 @@ struct se_lun *core_tpg_alloc_lun(
>         u64 unpacked_lun)
>  {
>         struct se_lun *lun;
> +       int ret;
> 
>         lun = kzalloc(sizeof(*lun), GFP_KERNEL);
>         if (!lun) {
>                 pr_err("Unable to allocate se_lun memory\n");
>                 return ERR_PTR(-ENOMEM);
>         }
> +
> +       lun->lun_stats = alloc_percpu(struct scsi_port_stats);
> +       if (!lun->lun_stats) {
> +               pr_err("Unable to allocate se_lun stats memory\n");
> +               ret = -ENOMEM;
> +               goto free_lun;
> +       }
> +

There is dev->xcopy_lun that is used for cmd->se_lun, you have to
allocate and deallocate lun_stats for it to avoid NPE on XCOPY command.

>         lun->unpacked_lun = unpacked_lun;
>         atomic_set(&lun->lun_acl_count, 0);
>         init_completion(&lun->lun_shutdown_comp);
> @@ -628,6 +637,18 @@ struct se_lun *core_tpg_alloc_lun(
>         lun->lun_tpg = tpg;
> 
>         return lun;
> +
> +free_lun:
> +       kfree(lun);
> +       return ERR_PTR(-ENOMEM);
> +}
> +
> +void target_tpg_free_lun(struct rcu_head *head)
> +{
> +       struct se_lun *lun = container_of(head, struct se_lun, rcu_head);
> +
> +       free_percpu(lun->lun_stats);
> +       kfree(lun);
>  }
> 
>  int core_tpg_add_lun(
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 0a76bdfe5528..4ec66ca6c0ca 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1571,7 +1571,7 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
>                 return ret;
> 
>         cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
> -       atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
> +       this_cpu_inc(cmd->se_lun->lun_stats->cmd_pdus);
>         return 0;
>  }
>  EXPORT_SYMBOL(target_cmd_parse_cdb);
> @@ -2597,8 +2597,8 @@ static void target_complete_ok_work(struct work_struct *work)
>                     !(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL))
>                         goto queue_status;
> 
> -               atomic_long_add(cmd->data_length,
> -                               &cmd->se_lun->lun_stats.tx_data_octets);
> +               this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
> +                            cmd->data_length);
>                 /*
>                  * Perform READ_STRIP of PI using software emulation when
>                  * backend had PI enabled, if the transport will not be
> @@ -2621,14 +2621,14 @@ static void target_complete_ok_work(struct work_struct *work)
>                         goto queue_full;
>                 break;
>         case DMA_TO_DEVICE:
> -               atomic_long_add(cmd->data_length,
> -                               &cmd->se_lun->lun_stats.rx_data_octets);
> +               this_cpu_add(cmd->se_lun->lun_stats->rx_data_octets,
> +                            cmd->data_length);
>                 /*
>                  * Check if we need to send READ payload for BIDI-COMMAND
>                  */
>                 if (cmd->se_cmd_flags & SCF_BIDI) {
> -                       atomic_long_add(cmd->data_length,
> -                                       &cmd->se_lun->lun_stats.tx_data_octets);
> +                       this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
> +                                    cmd->data_length);
>                         ret = cmd->se_tfo->queue_data_in(cmd);
>                         if (ret)
>                                 goto queue_full;
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index c4d9116904aa..e73fb224625d 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -744,9 +744,9 @@ struct se_port_stat_grps {
>  };
> 
>  struct scsi_port_stats {
> -       atomic_long_t   cmd_pdus;
> -       atomic_long_t   tx_data_octets;
> -       atomic_long_t   rx_data_octets;
> +       u32                     cmd_pdus;
> +       u32                     tx_data_octets;
> +       u32                     rx_data_octets;

I belive that there is no reason to have 32-bits counters in our
century. 
[SPC-5] 7.3.9.2 General Access Statistics and Performance log parameter
has 64-bits counters.
RFC 4455 (MIB SCSI) states that 64bit counters are mandatory for systems
with speed >= 4Gbs.

Especially for t(r)x_data_octets that in 32-bit counter presentation has
just 12 meaning bits actually.

>  };
> 
>  struct se_lun {
> @@ -773,7 +773,7 @@ struct se_lun {
>         spinlock_t              lun_tg_pt_gp_lock;
> 
>         struct se_portal_group  *lun_tpg;
> -       struct scsi_port_stats  lun_stats;
> +       struct scsi_port_stats  __percpu *lun_stats;
>         struct config_group     lun_group;
>         struct se_port_stat_grps port_stat_grps;
>         struct completion       lun_shutdown_comp;
> --
> 2.47.1
> 
> 
