From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Tue, 9 Jan 2018 16:23:05 -0700
Message-ID: <20180109232305.GH15154@localhost.localdomain>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org>
 <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <20180109164540.GA11861@infradead.org>
 <27ebbe5f-e06b-a800-5518-ec63d65d142a@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34997 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753329AbeAIXTq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jan 2018 18:19:46 -0500
Content-Disposition: inline
In-Reply-To: <27ebbe5f-e06b-a800-5518-ec63d65d142a@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Tue, Jan 09, 2018 at 03:50:44PM -0500, Douglas Gilbert wrote:
> Have you tried to do any serious work with <linux/nvme_ioctl.h> and
> say compared it with FreeBSD and Microsoft's approach? No prize for
> guessing which one is worst (and least extensible). Looks like the
> Linux pass-through was at the end of a ToDo list and was "designed"
> at 5 a.m in the morning.

What the heck are you talking about? FreeBSD's NVMe passthrough is near
identical to Linux, and Linux's existed years prior.
 
You're not even touching the nvme subsystem, so why are you copying the
linux-nvme mailing list to help you with a non-NVMe device? Please take
your ignorant and dubious claims elsewhere.
