From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Mon, 15 Jan 2018 17:46:05 +0530
Message-ID: <6d58b9ecb0fbb23b04545bb736ca8a39@mail.gmail.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org> <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <1515601333.2745.8.camel@wdc.com> <d6da790a-8248-c71d-6643-6ae3107989d0@interlog.com>
 <e407e98c266c060412bfa8b64ded18df@mail.gmail.com> <20180111174619.GA2860@localhost.localdomain>
 <780f280162fa01c41f15aaeb64503ffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:32946 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933568AbeAOMQI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 07:16:08 -0500
Received: by mail-io0-f172.google.com with SMTP id t63so12873069iod.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 04:16:08 -0800 (PST)
In-Reply-To: <780f280162fa01c41f15aaeb64503ffd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Keith Busch <keith.busch@intel.com>
Cc: dgilbert@interlog.com, Bart Van Assche <Bart.VanAssche@wdc.com>, hch@infradead.org, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-nvme@lists.infradead.org, Peter Rivera <peter.rivera@broadcom.com>, linux-scsi@vger.kernel.org

This patch is not yet included because of the ongoing discussion.

Chris H, Martin et all -  How are we moving forward with this patch ?

Thanks, Kashyap

> -----Original Message-----
> From: Sathya Prakash Veerichetty [mailto:sathya.prakash@broadcom.com]
> Sent: Thursday, January 11, 2018 11:37 PM
> To: Keith Busch
> Cc: dgilbert@interlog.com; Bart Van Assche; hch@infradead.org; Kashyap
> Desai; Shivasharan Srikanteshwara; Sumit Saxena; linux-
> nvme@lists.infradead.org; Peter Rivera; linux-scsi@vger.kernel.org
> Subject: RE: [PATCH 13/14] megaraid_sas: NVME passthru command support
>
> >>So even when used as a RAID member, there will be a device handle at
> /dev/sdX for each NVMe device the megaraid controller manages?
> In megaraid controller, you can expose bare NVMe drives and RAID volumes
> created out of NVMe drives, when the RAID volume is created underlying
> member drives will not have /dev/sdX entries associated with them, however
> for bare NVMe drives there will be associated /dev/sdX entries.
