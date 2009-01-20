From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Q] In sg_io_v4 what to use as flag for "queue at_head"
Date: Tue, 20 Jan 2009 09:05:41 +0200
Message-ID: <497577C5.6080604@panasas.com>
References: <49746197.200@panasas.com> <4974BBC5.3080001@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:21878 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754286AbZATHFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 02:05:50 -0500
In-Reply-To: <4974BBC5.3080001@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Douglas Gilbert <dougg@torque.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Douglas Gilbert wrote:
> 
> or (adding "_TA_" for task attribute):
>    enum {
>          BSG_TA_DEFAULT = 0,  // lk 2.4, 2.6 series: head of queue
>          BSG_TA_HEAD_OF_Q = 0x1000,
>          BSG_TA_SIMPLE,
>          BSG_TA_ORDERED,
>          BSG_TA_ACA,
>          ....

BSG_TA_HEAD_OF_Q I understand that's like today. What are the meaning
of the other values? Anyway I only have 2 values to implement I don't want
to add more values then I use, and have to comment NOT SUPPORTED next
to them. When used I can add them later.

Please Note that I was asking about the at_head=0/1 of the blk_execute_rq_xxx
calls. This means that it is not transport specific at all, it is a Boolean behavior
common to all transports, governed by the request submission layer.
If task_attribute is something related to SAM-4 then surly that is not it, because
I'm looking for a flag that is independent of scsi. If later I will need that SAM-4
thing it will be taken.

> 
> I would prefer using the request_attr field.
> 
> Tomo, what do you think?
> 
> 
> Doug Gilbert

And please, you never explained, what is "request_priority" for?
What was your original intention?

Thanks
Boaz
