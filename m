From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Mon, 15 Jan 2018 22:06:58 -0500
Message-ID: <yq1inc2y019.fsf@oracle.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <20180108100531.GA6967@infradead.org>
        <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
        <1515601333.2745.8.camel@wdc.com>
        <d6da790a-8248-c71d-6643-6ae3107989d0@interlog.com>
        <e407e98c266c060412bfa8b64ded18df@mail.gmail.com>
        <20180111174619.GA2860@localhost.localdomain>
        <780f280162fa01c41f15aaeb64503ffd@mail.gmail.com>
        <6d58b9ecb0fbb23b04545bb736ca8a39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeAPDHr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 22:07:47 -0500
In-Reply-To: <6d58b9ecb0fbb23b04545bb736ca8a39@mail.gmail.com> (Kashyap
        Desai's message of "Mon, 15 Jan 2018 17:46:05 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Keith Busch <keith.busch@intel.com>, dgilbert@interlog.com, Bart Van Assche <Bart.VanAssche@wdc.com>, hch@infradead.org, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-nvme@lists.infradead.org, Peter Rivera <peter.rivera@broadcom.com>, linux-scsi@vger.kernel.org


Kashyap,

> This patch is not yet included because of the ongoing discussion.
>
> Chris H, Martin et all -  How are we moving forward with this patch ?

Well, I guess I'll go ahead and queue it up even through I am no fan of
these dreadful driver-specific ioctl interfaces. I really wish the SCSI
Controller Commands had taken off so we had a standard interface for
dealing with RAID controllers and devices behind them.

-- 
Martin K. Petersen	Oracle Linux Engineering
