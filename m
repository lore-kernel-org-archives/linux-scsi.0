From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Thu, 11 Jan 2018 11:07:16 -0700
Message-ID: <780f280162fa01c41f15aaeb64503ffd@mail.gmail.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org> <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <1515601333.2745.8.camel@wdc.com> <d6da790a-8248-c71d-6643-6ae3107989d0@interlog.com>
 <e407e98c266c060412bfa8b64ded18df@mail.gmail.com> <20180111174619.GA2860@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35289 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbeAKSHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2018 13:07:18 -0500
Received: by mail-qk0-f176.google.com with SMTP id w1so5438965qka.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2018 10:07:18 -0800 (PST)
In-Reply-To: <20180111174619.GA2860@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: dgilbert@interlog.com, Bart Van Assche <Bart.VanAssche@wdc.com>, hch@infradead.org, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-nvme@lists.infradead.org, Peter Rivera <peter.rivera@broadcom.com>, linux-scsi@vger.kernel.org

>>So even when used as a RAID member, there will be a device handle at
/dev/sdX for each NVMe device the megaraid controller manages?
In megaraid controller, you can expose bare NVMe drives and RAID volumes
created out of NVMe drives, when the RAID volume is created underlying
member drives will not have /dev/sdX entries associated with them, however
for bare NVMe drives there will be associated /dev/sdX entries.
