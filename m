From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH] 2.6.0-test9 - MPT Fusion driver 2.05.00.05 update
Date: Tue, 25 Nov 2003 22:15:37 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311251315.AA02792@fukuchi.jp.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E57035AA306@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:26297 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262491AbTKYNQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 08:16:01 -0500
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75]) by fgwmail6.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id hAPDFxQA003304 for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 22:15:59 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s0.gw.fujitsu.co.jp by m5.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id hAPDFxrm029955 for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 22:15:59 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail503.fjmail.jp.fujitsu.com (fjmail503-0.fjmail.jp.fujitsu.com [10.59.80.100]) by s0.gw.fujitsu.co.jp (8.12.10)
	id hAPDFwZh029130 for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 22:15:58 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail503.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HOW006SESUL6O@fjmail503.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Tue, 25 Nov 2003 22:15:58 +0900 (JST)
In-reply-to: <0E3FA95632D6D047BA649F95DAB60E57035AA306@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: James.Bottomley@steeleye.com, akpm@osdl.org, linux-scsi@vger.kernel.org

Moore, Eric Dean wrote:
>James: Please apply the patch below to the 2.6 tree.
>
>If you find this inline patch malformed,
>please kindly download this patch from this URL:
>ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/

Hello Eric,

I confirmed that this patch solves my problem.
>>Date: Thu, 30 Oct 2003 20:00:06 +0900
>>Subject: Server freeze when LSI53C1030 didn't send reply message

Thanks,
Fukuchi

---
M.Fukuchi <fukuchi.masao@jp.fujitsu.com>
