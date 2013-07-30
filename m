From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 3/7] scsi: ufs: fix the setting interrupt aggregation
 counter
Date: Tue, 30 Jul 2013 22:01:01 +0900
Message-ID: <002701ce8d24$d7b36380$871a2a80$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <001e01ce8a06$884df3d0$98e9db70$%jun@samsung.com>
 <51F613D4.7080509@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42639 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3G3NBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 09:01:04 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQR009Z22TN8DS0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 30 Jul 2013 22:01:02 +0900 (KST)
In-reply-to: <51F613D4.7080509@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Mon, July 29, 2013, Subhash Jadavani wrote:
> On 7/26/2013 7:16 PM, Seungwon Jeon wrote:
> > LACTH(Interrupt aggregation counter threshold) value is allowed
> 
> I guess you mean "IACTH" not "LACTH". Other than this, change looks good
> to me.
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Right, Typo will be fixed.

Thanks,
Seungwon Jeon

