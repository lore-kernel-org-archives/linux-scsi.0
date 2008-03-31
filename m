From: Ke Wei <kewei@marvell.com>
Subject: Re: [PATCH 3/9][RESEND] mvsas : interrupt handling
Date: Mon, 31 Mar 2008 18:23:44 +0800
Message-ID: <47F0BBB0.7030606@marvell.com>
References: <47EB449F.20201@marvell.com> <1206889797.4224.20.camel@localhost.localdomain>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:49269 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751713AbYCaKXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 06:23:53 -0400
In-Reply-To: <1206889797.4224.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

James Bottomley wrote:
> This tasklet usage doesn't quite look right.  What a tasklet does is
> defer processing until after all interrupts have completed.  It's
> commonly used for aggregation, which is why scsi_done simply queues for
> the block softirq (tasklet).  However, for mvsas, I don't see any
> benefit to defering the work to a tasklet.

OK, I understood. I will remove tasklet feature.

> 
> Additionally, for the non MSI case, doesn't the interrupt, which is
> level triggered, fail to deassert because we haven't cleared any
> registers?
> 
I don't understood what you said. What's your meaning about non MSI case. 

Thank you.
Ke

