From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 18:10:53 +0900
Message-ID: <4A093D1D.5060408@gmail.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org> <4A093782.80701@panasas.com> <4A093C54.2060706@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:17332 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZELJRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2009 05:17:13 -0400
In-Reply-To: <4A093C54.2060706@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>

Tejun Heo wrote:
...
> Please consider write failing after successfully writing certain
> number of bytes.  A failed write command MUST NOT cause any actual
> write on the device.
> 
> Residual count is not about how many bytes have been transferred.  The
> number of transferred bytes itself doesn't mean a thing because it
> changes depending on which transfer protocol is used regardless of
> where the actual failure is.  Residual count is about how many bytes
> have been actually produced or consumed and when a command fails none
> should have been.

Please note that in the above 'command' and 'residual count' are not
as defined in SCSI.  Those terms refer to how those concepts are used
in the kernel and via SG_IO interface.

Thanks.

-- 
tejun
