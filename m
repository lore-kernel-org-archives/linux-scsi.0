From: Jens Axboe <axboe@kernel.dk>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 08:32:00 -0700
Message-ID: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
References: <20170227152955.1362aabb@xeon-e3>
 <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35154 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdB1Pc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 10:32:26 -0500
Received: by mail-io0-f173.google.com with SMTP id j18so11545628ioe.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 07:32:02 -0800 (PST)
In-Reply-To: <20170228140812.GC20197@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Stephen Hemminger <stephen@networkplumber.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

On 02/28/2017 07:08 AM, Christoph Hellwig wrote:
> On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:
>> Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each I/O")
>>
>> but that is already in linux-next.
>>
>> Noticed another place where memset(of the data was being done not the extra bits.
>> Tried this, but didn't fix it either...
> 
> Are you using blk-mq or the legacy request code?

Stephen doesn't have MQ set in the config he posted, I'm assuming he didn't
boot with scsi_mod.use_blk_mq=true. In a previous email, I asked if turning
on MQ makes a difference.

-- 
Jens Axboe
