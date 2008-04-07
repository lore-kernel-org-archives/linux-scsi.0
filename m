From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Mon, 07 Apr 2008 20:31:38 +0900
Message-ID: <47FA061A.8000107@gmail.com>
References: <1207155180-8069-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>	<1207155180-8069-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>	<47F45035.8060003@gmail.com> <20080407200756G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:7453 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYDGLbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 07:31:45 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1380616wff.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2008 04:31:45 -0700 (PDT)
In-Reply-To: <20080407200756G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

FUJITA Tomonori wrote:
>> Maybe we need yet another flag indicating padding space
>> availability?
> 
> How about doing the exact same thing that the drain buffer does? We
> can put pre-allocated buffer to a queue and save one sg entry for it.

Each sg entry should be aligned so extra sg doesn't really help or am I 
missing something?

Thanks.

-- 
tejun
