From: Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: qlogic lockdep warning
Date: Thu, 21 Jan 2010 17:14:14 +0800
Message-ID: <7b6bb4a51001210114g1b2ec290g3fdf098a651b6b38@mail.gmail.com>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
	 <1264062159.4283.1125.camel@laptop>
	 <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
	 <1264064527.4283.1139.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752592Ab0AUJOS@vger.kernel.org>
In-Reply-To: <1264064527.4283.1139.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@hansenpartnership.com>, James.Bottomley@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 21, 2010 at 5:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-21 at 16:46 +0800, Xiaotian Feng wrote:
>> qla24xx_msix_default is using spin_lock_irq and spin_unlock_irq within
>> the irq handler...
>> I think convert to spin_lock_irqsave/spin_unlock_irqrestore can solve
>> this warning.
>
> Not only that it'll actually solve a bug too ;-)
>
> Also,
>
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?

Ah, just realized it by your examples :-) Sorry for the bad manner in e-mail...

>
>
