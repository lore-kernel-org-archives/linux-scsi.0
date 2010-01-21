From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: qlogic lockdep warning
Date: Thu, 21 Jan 2010 10:02:07 +0100
Message-ID: <1264064527.4283.1139.camel@laptop>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
	 <1264062159.4283.1125.camel@laptop>
	 <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0AUJCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2010 04:02:14 -0500
In-Reply-To: <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@hansenpartnership.com>, James.Bottomley@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Thu, 2010-01-21 at 16:46 +0800, Xiaotian Feng wrote:
> qla24xx_msix_default is using spin_lock_irq and spin_unlock_irq within
> the irq handler...
> I think convert to spin_lock_irqsave/spin_unlock_irqrestore can solve
> this warning.

Not only that it'll actually solve a bug too ;-)

Also,

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

