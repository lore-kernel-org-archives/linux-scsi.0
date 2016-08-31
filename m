From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] fusion: mptbase: Remove deprecated
 create_singlethread_workqueue
Date: Wed, 31 Aug 2016 10:25:44 -0400
Message-ID: <20160831142544.GN12660@htj.duckdns.org>
References: <cover.1472583639.git.bhaktipriya96@gmail.com>
 <05a0e321c521d102e5a908bb4173e684e8a16c9a.1472583639.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35085 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934976AbcHaOZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2016 10:25:45 -0400
Content-Disposition: inline
In-Reply-To: <05a0e321c521d102e5a908bb4173e684e8a16c9a.1472583639.git.bhaktipriya96@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 31, 2016 at 12:33:25AM +0530, Bhaktipriya Shridhar wrote:
> The workqueues "ioc->reset_work_q" and "ioc->fw_event_q" queue a single
> work item &ioc->fault_reset_work and &fw_event->work, respectively and
> hence don't require ordering. Hence, they have been converted to use
> alloc_workqueue().
> 
> The WQ_MEM_RECLAIM flag has been set to ensure forward progress under
> memory pressure since the workqueue belongs to a storage driver which is
> being used on a memory reclaim path.
> 
> Since there are fixed number of work items, explicit concurrency
> limit is unnecessary here.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
