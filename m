From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 07/18] lpfc: NVME Initiator: Base modifications Part E
Date: Wed, 8 Feb 2017 11:13:27 -0800
Message-ID: <5b0f8560-a1ca-1b9a-3951-96e251c7b1a9@broadcom.com>
References: <58990208.nZVFaqC7RkseErlq%jsmart2021@gmail.com>
 <5881e84b-c932-f812-7f41-a16152d12106@suse.de>
 <52f4f81e-2353-4da2-7ce9-a7cd7796e1f7@gmail.com>
 <20170208124754.GA23225@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33737 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdBHTkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 14:40:35 -0500
Received: by mail-yw0-f181.google.com with SMTP id u68so92531390ywg.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 11:40:10 -0800 (PST)
In-Reply-To: <20170208124754.GA23225@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, sagi@grimberg.me, linux-nvme@lists.infradead.org, Johannes Thumshirn <jthumshirn@suse.de>


On 2/8/2017 4:47 AM, Christoph Hellwig wrote:
> On Tue, Feb 07, 2017 at 06:32:30PM -0800, James Smart wrote:
>> I realize I cut these in a silly way.  In the v1 patches, I had a big patch
>> that I then cut into 6 parts, by file.  In the v2 patches, I tried to keep
>> the patches as is, and address the comments in the respective patch the
>> comment came from. Which resulted in 3/8 with an old reference, but patch
>> 8/8 being the one that reverted this reverence. Sorry..  I'll recut and
>> repost.
> This whole split doesn't make sense - either the patches are logically
> split, in which case they can be posted separately, or they belong
> together in which case they should be sent together.  But the size
> of them suggest to me they probably need to be broken down to logically
> separate patches.
>
> And can you please switch to using git-send-email to send the patches
> straight from a git branch?  There are lot of patch formatting issues
> with the lpfc patches, and that should fix most of them instantly.
>

Ok. I will see if they can be further split. I don't have a lot of hope 
beyond a couple splits. So, the resulting patches will be large.

git-send-email: I'll talk to you offline.

-- james
