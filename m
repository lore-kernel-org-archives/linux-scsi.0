From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Mon, 07 Apr 2008 22:24:32 +0900
Message-ID: <47FA2090.4040005@gmail.com>
References: <47F45035.8060003@gmail.com>	<20080407200756G.fujita.tomonori@lab.ntt.co.jp>	<47FA061A.8000107@gmail.com> <20080407221103Y.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:49714 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbYDGNYj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 09:24:39 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1308545wah.23
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2008 06:24:39 -0700 (PDT)
In-Reply-To: <20080407221103Y.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

FUJITA Tomonori wrote:
> On Mon, 07 Apr 2008 20:31:38 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>>> Maybe we need yet another flag indicating padding space
>>>> availability?
>>> How about doing the exact same thing that the drain buffer does? We
>>> can put pre-allocated buffer to a queue and save one sg entry for it.
>> Each sg entry should be aligned so extra sg doesn't really help or am I 
>> missing something?
> 
> Sorry, please scratch the previous mail. I think that I misunderstood
> what you meant.
> 
> The current code does padding only for requests that we call
> __blk_rq_map_user (bio_copy_user) for. You meant that if we create a
> new flag like REQ_NEED_PADDING and set it in blk_rq_map_user,
> blk_rq_map_sg can do padding only when it was set.

Yeap, that's what I meant.

-- 
tejun
