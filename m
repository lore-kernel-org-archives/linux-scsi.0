From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: Re: [PATCH 7/9] scsi: bnx2fc: Use zeroing allocator rather than
 allocator/memset
Date: Thu, 4 Jan 2018 13:08:31 +0530
Message-ID: <20180104073831.GA5862@himanshu-Vostro-3559>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
 <1514647712-6332-8-git-send-email-himanshujha199640@gmail.com>
 <yq1o9mauoz3.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:40553 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbeADHim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 02:38:42 -0500
Content-Disposition: inline
In-Reply-To: <yq1o9mauoz3.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, aacraid@adaptec.com, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello Martin,

On Thu, Jan 04, 2018 at 01:17:52AM -0500, Martin K. Petersen wrote:
> 
> Himanshu,
> 
> > Use dma_zalloc_coherent instead of dma_alloc_coherent followed by
> > memset 0.
> 
> Does not apply to 4.16/scsi-queue. Please resubmit. Thanks!

No problem, I will resend the patch.

scsi: qla4xxx: Use zeroing allocator rather than allocator/memset --Applied
scsi: qla2xxx: Use zeroing allocator rather than allocator/memset --Applied
scsi: qedi: Use zeroing allocator instead of allocator/memset --Resend
scsi: mvsas: Use zeroing allocator rather than allocator/memset
scsi: fnic: Use zeroing allocator rather than allocator/memset
scsi: dpt_i2o: Use zeroing allocator rather than allocator/memset
scsi: bnx2fc: Use zeroing allocator rather than allocator/memset --Resend
scsi: bfa: Use zeroing allocator rather than allocator/memset --Applied
scsi: bnx2i: Use zeroing allocator rather than allocator/memset --Applied

But do I also need to send those mentioned above, which didn't receive
any response from you ?

Also, I later sent a patch for fnic after this series which can be
applied after or before this series whichever is suitable to you.

Thanks
Himanshu Jha
