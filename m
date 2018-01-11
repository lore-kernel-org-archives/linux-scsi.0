From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Thu, 11 Jan 2018 10:46:20 -0700
Message-ID: <20180111174619.GA2860@localhost.localdomain>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org>
 <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <1515601333.2745.8.camel@wdc.com>
 <d6da790a-8248-c71d-6643-6ae3107989d0@interlog.com>
 <e407e98c266c060412bfa8b64ded18df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:3310 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934792AbeAKRnR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jan 2018 12:43:17 -0500
Content-Disposition: inline
In-Reply-To: <e407e98c266c060412bfa8b64ded18df@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: dgilbert@interlog.com, Bart Van Assche <Bart.VanAssche@wdc.com>, hch@infradead.org, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-nvme@lists.infradead.org, Peter Rivera <peter.rivera@broadcom.com>, linux-scsi@vger.kernel.org

On Wed, Jan 10, 2018 at 03:14:40PM -0700, Sathya Prakash Veerichetty wrote:
> In the case of RAID controllers, all of those drives and RAID volumes
> are exposed to the OS as generic SCSI devices

So even when used as a RAID member, there will be a device handle at
/dev/sdX for each NVMe device the megaraid controller manages?
