Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0D5ECAAD4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 02:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiIACrx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Aug 2022 22:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiIACrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2022 22:47:51 -0400
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com [85.158.142.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52848F4935
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 19:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1662000467; i=@fujitsu.com;
        bh=+Y8nd+eZrZ315LpSmWo0jalQbY1Q6sUAbzM5b56m6LM=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=CgUPP0ybwgepUtgpNR9eZAhlBdu7xc/uAo2rDqSVnv4KD6y7s1sUmNgnb9v7nx8m3
         BSYqBlXnWpAnOvGuN3zSjFjXlbPKr+EU2jJ1Q7KStR9OpTGrGMdDYVCbozogPCLtWr
         +QD2SROoqj4F9xL8Qyrhv76xKAqUWE8xMwdxFbmspe2kd6VthQlA82DBU5rv8fF0k8
         P0S+maUPTse7XzODAl0umPhWEaGT+rWZmAYqvsoE/DahHXF/+1995azi7ip+cZPThZ
         0tCvxxKGSx6LvEy0VwIkCq9YhsUViXlpnPzHKlFxszWeLUtdaaV3y1dBIK7bs095Yz
         9BKQzMrpCWaqQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRWlGSWpSXmKPExsViZ8MxSTdIViD
  Z4ORPSYtpH34yW+xZNInJYuXqo0wWi25sY7LYtL+J1aL7+g42i+XH/zFZ/J10g9Xi0ORmJgdO
  j8tXvD1ajrxl9Ziw6ACjx+6bDWweH5/eYvF4v+8qm8fm09UenzfJBXBEsWbmJeVXJLBmfD6+n
  anggUXF7hcNjA2MBw26GLk4hAS2MEos7HnKBOGsYJL41XOKDcLZxihxdNFj9i5GTg5eATuJyV
  0vwGwWARWJqydnQMUFJU7OfMICYosKREg8fDQJzBYWMJVYO3UhG4jNLCAucevJfCYQW0QgVmJ
  Z6zxWkAXMAo1MEhP37GUGSQgJWEi8bf/ICmKzCWhI3Gu5yQhicwpYSqzf3skOMchCYvGbg1C2
  vMT2t3PAeiUEFCWOdP5lgbArJVo//IKy1SSuntvEPIFReBaSW2chuWkWkrGzkIxdwMiyitE2q
  SgzPaMkNzEzR9fQwEDX0NAUQlua6yVW6SbqpZbq5uUXlWToGuollhfrpRYX6xVX5ibnpOjlpZ
  ZsYgTGb0pxytEdjMf2/dI7xCjJwaQkyluxmD9ZiC8pP6UyI7E4I76oNCe1+BCjDAeHkgTvB3G
  BZCHBotT01Iq0zBxgKoFJS3DwKInwcosApXmLCxJzizPTIVKnGO05ps7+t5+ZYzmYnPm17QAz
  x6Z9XQeYhVjy8vNSpcR5K6WB2gRA2jJK8+CGwlLfJUZZKWFeRgYGBiGegtSi3MwSVPlXjOIcj
  ErCvLukgKbwZOaVwO1+BXQWE9BZ02fyg5xVkoiQkmpgUtpx9syHC/EOvD8D9v+qO6C9lTO58D
  FLfNTT4HB73Rn8HxyLmjfoLN34q3K25yltTYXXRuHK2XUOxx62vN6zL0My+0PM85+RJ2YVdyv
  xaPu9yhL12CdRF83MXzQl2n9WuaSyZWyUxErhPHHfyYpeW4Pf8L28Hahndrfic2h3yZzpIncq
  m29qf9t46BRPeY23M88e7Tf7jS8wFbmXHrdpEp/I/N3Y/cK9iVtkl5p7FPn7rr4VtDtz75rVd
  S9PGPcLf63oa9+ofU006JbRvYOpjp813t2vu9vKsGnpxfwlWk+eLhUXkNJ7tGp7885j360WN5
  xVntxrO/2uS1vPJcEdbR6xOsHiUiF7ty7vEH6hxFKckWioxVxUnAgArwMcW/gDAAA=
X-Env-Sender: lizhijian@fujitsu.com
X-Msg-Ref: server-3.tower-732.messagelabs.com!1662000465!411293!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23291 invoked from network); 1 Sep 2022 02:47:46 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-3.tower-732.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 1 Sep 2022 02:47:46 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id B98661000CC;
        Thu,  1 Sep 2022 03:47:45 +0100 (BST)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id AC9DD1000C2;
        Thu,  1 Sep 2022 03:47:45 +0100 (BST)
Received: from [10.167.226.45] (10.167.226.45) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 1 Sep 2022 03:47:41 +0100
Message-ID: <7c8c4726-2244-3396-b2a3-9e7d02fc441a@fujitsu.com>
Date:   Thu, 1 Sep 2022 10:46:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: core: Fix a use-after-free
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220826002635.919423-1-bvanassche@acm.org>
From:   Li Zhijian <lizhijian@fujitsu.com>
In-Reply-To: <20220826002635.919423-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.45]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 26/08/2022 08:26, Bart Van Assche wrote:
> There are two .exit_cmd_priv implementations. Both implementations use
> resources associated with the SCSI host. Make sure that these resources are
> still available when .exit_cmd_priv is called by waiting inside
> scsi_remove_host() until the tag set has been freed.
>
> This patch fixes the following use-after-free:
>
> ==================================================================
> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
> Read of size 8 at addr ffff888100337000 by task multipathd/16727
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x34/0x44
>   print_report.cold+0x5e/0x5db
>   kasan_report+0xab/0x120
>   srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>   scsi_mq_exit_request+0x4d/0x70
>   blk_mq_free_rqs+0x143/0x410
>   __blk_mq_free_map_and_rqs+0x6e/0x100
>   blk_mq_free_tag_set+0x2b/0x160
>   scsi_host_dev_release+0xf3/0x1a0
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   scsi_device_dev_release_usercontext+0x4c1/0x4e0
>   execute_in_process_context+0x23/0x90
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   scsi_disk_release+0x3f/0x50
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   disk_release+0x17f/0x1b0
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   dm_put_table_device+0xa3/0x160 [dm_mod]
>   dm_put_device+0xd0/0x140 [dm_mod]
>   free_priority_group+0xd8/0x110 [dm_multipath]
>   free_multipath+0x94/0xe0 [dm_multipath]
>   dm_table_destroy+0xa2/0x1e0 [dm_mod]
>   __dm_destroy+0x196/0x350 [dm_mod]
>   dev_remove+0x10c/0x160 [dm_mod]
>   ctl_ioctl+0x2c2/0x590 [dm_mod]
>   dm_ctl_ioctl+0x5/0x10 [dm_mod]
>   __x64_sys_ioctl+0xb4/0xf0
>   dm_ctl_ioctl+0x5/0x10 [dm_mod]
>   __x64_sys_ioctl+0xb4/0xf0
>   do_syscall_64+0x3b/0x90
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Li Zhijian <lizhijian@fujitsu.com>
> Reported-by: Li Zhijian <lizhijian@fujitsu.com>
> Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

I tested this after reverted previous 4 patches(https://lore.kernel.org/linux-scsi/20220821220502.13685-1-bvanassche@acm.org/).
Above UFA is gone, feel free to add my tested-by :)

Thanks
Zhijian


> ---
>   drivers/scsi/hosts.c      | 16 +++++++++++++---
>   drivers/scsi/scsi_lib.c   |  6 +++++-
>   drivers/scsi/scsi_priv.h  |  2 +-
>   drivers/scsi/scsi_scan.c  |  1 +
>   drivers/scsi/scsi_sysfs.c |  1 +
>   include/scsi/scsi_host.h  |  2 ++
>   6 files changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 26bf3b153595..9857dba09c95 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -182,6 +182,15 @@ void scsi_remove_host(struct Scsi_Host *shost)
>   	mutex_unlock(&shost->scan_mutex);
>   	scsi_proc_host_rm(shost);
>   
> +	/*
> +	 * New SCSI devices cannot be attached anymore because of the SCSI host
> +	 * state so drop the tag set refcnt. Wait until the tag set refcnt drops
> +	 * to zero because .exit_cmd_priv implementations may need the host
> +	 * pointer.
> +	 */
> +	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
> +	wait_for_completion(&shost->tagset_freed);
> +
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	if (scsi_host_set_state(shost, SHOST_DEL))
>   		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
> @@ -245,6 +254,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (error)
>   		goto fail;
>   
> +	kref_init(&shost->tagset_refcnt);
> +	init_completion(&shost->tagset_freed);
> +
>   	/*
>   	 * Increase usage count temporarily here so that calling
>   	 * scsi_autopm_put_host() will trigger runtime idle if there is
> @@ -317,6 +329,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	pm_runtime_disable(&shost->shost_gendev);
>   	pm_runtime_set_suspended(&shost->shost_gendev);
>   	pm_runtime_put_noidle(&shost->shost_gendev);
> +	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
>    fail:
>   	return error;
>   }
> @@ -350,9 +363,6 @@ static void scsi_host_dev_release(struct device *dev)
>   		kfree(dev_name(&shost->shost_dev));
>   	}
>   
> -	if (shost->tag_set.tags)
> -		scsi_mq_destroy_tags(shost);
> -
>   	kfree(shost->shost_data);
>   
>   	ida_free(&host_index_ida, shost->host_no);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4dbd29ab1dcc..1f30e0c54e55 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1976,9 +1976,13 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   	return blk_mq_alloc_tag_set(tag_set);
>   }
>   
> -void scsi_mq_destroy_tags(struct Scsi_Host *shost)
> +void scsi_mq_free_tags(struct kref *kref)
>   {
> +	struct Scsi_Host *shost = container_of(kref, typeof(*shost),
> +					       tagset_refcnt);
> +
>   	blk_mq_free_tag_set(&shost->tag_set);
> +	complete(&shost->tagset_freed);
>   }
>   
>   /**
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 429663bd78ec..f385b3f04d6e 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -94,7 +94,7 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
>   extern void scsi_requeue_run_queue(struct work_struct *work);
>   extern void scsi_start_queue(struct scsi_device *sdev);
>   extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
> -extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
> +extern void scsi_mq_free_tags(struct kref *kref);
>   extern void scsi_exit_queue(void);
>   extern void scsi_evt_thread(struct work_struct *work);
>   
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 91ac901a6682..5d27f5196de6 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -340,6 +340,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   		kfree(sdev);
>   		goto out;
>   	}
> +	kref_get(&sdev->host->tagset_refcnt);
>   	sdev->request_queue = q;
>   	q->queuedata = sdev;
>   	__scsi_init_queue(sdev->host, q);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index aa70d9282161..5d61f58399dc 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1476,6 +1476,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
>   	mutex_unlock(&sdev->state_mutex);
>   
>   	blk_mq_destroy_queue(sdev->request_queue);
> +	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>   	cancel_work_sync(&sdev->requeue_work);
>   
>   	if (sdev->host->hostt->slave_destroy)
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index b6e41ee3d566..9b0a028bf053 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -557,6 +557,8 @@ struct Scsi_Host {
>   	struct scsi_host_template *hostt;
>   	struct scsi_transport_template *transportt;
>   
> +	struct kref		tagset_refcnt;
> +	struct completion	tagset_freed;
>   	/* Area to keep a shared tag map */
>   	struct blk_mq_tag_set	tag_set;
>   

