From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v8 0/7] ZBC / Zoned block device support
Date: Tue, 18 Oct 2016 19:49:49 -0600
Message-ID: <48383eb2-e982-abf8-ce18-2b0117dd27b9@kernel.dk>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
 <2a80d950-c831-9ac6-1969-dc6386e58236@kernel.dk>
 <yq1twc9f9o3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35846 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754993AbcJSBuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 21:50:04 -0400
Received: by mail-it0-f51.google.com with SMTP id 139so91485809itm.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 18:50:03 -0700 (PDT)
In-Reply-To: <yq1twc9f9o3.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>

On 10/18/2016 06:46 PM, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:
>
> Jens> This is starting to look mergeable to me.
>
> Yup.
>
> Jens> Any objections in getting this applied for 4.10? Looks like 6/7
> Jens> should go through the SCSI tree, but I can queue up the rest.
>
> I'm OK with it at this point. Probably easier if either you or I take
> the whole lot.

I already queued up the other bits, if it's fine with you I'll add 6/7
as well.

-- 
Jens Axboe

