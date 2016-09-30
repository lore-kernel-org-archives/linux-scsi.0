From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] megaraid_sas: clean function declarations in megaraid_sas_fusion.c up
Date: Fri, 30 Sep 2016 16:34:34 +0200
Message-ID: <201609301634.34846.arnd@arndb.de>
References: <1475228702-21408-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:61645 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933050AbcI3OfD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2016 10:35:03 -0400
In-Reply-To: <1475228702-21408-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn, han.fei@zte.com.cn, tang.qiang007@zte.com.cn

On Friday 30 September 2016, Baoyou Xie wrote:
>  int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
> -void megaraid_sas_kill_hba(struct megasas_instance *instance);
>  
>  extern u32 megasas_dbg_lvl;
> -void megasas_sriov_heartbeat_handler(unsigned long instance_addr);
> -int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
> -                                 int initial);
> -void megasas_start_timer(struct megasas_instance *instance,
> -                       struct timer_list *timer,
> -                        void *fn, unsigned long interval);
>  extern struct megasas_mgmt_info megasas_mgmt_info;
>  extern unsigned int resetwaittime;
>  extern unsigned int dual_qdepth_disable;

I think you should remove all "extern" declarations from the .c file at the same
time here, and move them to an appropriate header, or remove them in case the symbol
is already gone and we only have the declaration left.

	Arnd
