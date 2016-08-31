From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] fusion/mptfc: Remove deprecated
 create_singlethread_workqueue
Date: Wed, 31 Aug 2016 10:25:30 -0400
Message-ID: <20160831142530.GM12660@htj.duckdns.org>
References: <cover.1472583639.git.bhaktipriya96@gmail.com>
 <0a490fd1f70f3010595444ca911d6e733f345684.1472583639.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:34158 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934976AbcHaOZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2016 10:25:33 -0400
Content-Disposition: inline
In-Reply-To: <0a490fd1f70f3010595444ca911d6e733f345684.1472583639.git.bhaktipriya96@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 31, 2016 at 12:33:05AM +0530, Bhaktipriya Shridhar wrote:
> The workqueue "fc_rescan_work_q" queues multiple work items viz
> &ioc->fc_rescan_work, &ioc->fc_lsc_work, &ioc->fc_setup_reset_work,
> which require strict execution ordering.
> Hence, an ordered dedicated workqueue has been used.
> 
> WQ_MEM_RECLAIM has been set since the workqueue is belongs to a storage
> driver which is being used on a memory reclaim path and hence, requires
> forward progress under memory pressure.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
