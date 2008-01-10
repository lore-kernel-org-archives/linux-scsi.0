From: Nick Warne <nick@ukfsn.org>
Subject: Re: Driver 'sd' needs updating
Date: Thu, 10 Jan 2008 17:41:20 +0000
Message-ID: <20080110174120.4cbde2cf@linuxamd.linicks.net>
References: <20080110085150.53addacf@linuxamd.linicks.net>
	<20080110203845E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759262AbYAJRle@vger.kernel.org>
In-Reply-To: <20080110203845E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 10 Jan 2008 20:38:45 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
 
> >    "Driver 'sd' needs updating - please use bus_type methods"
> > 
> > The warning never appeared in RC6, and all google reveals are other
> > peoples logs that are posted about other issues.
> > 
> > Do I need to fix up something here?
> 
> No, you don't. It's harmless, a side effect of:
> 
> commit 751bf4d7865e4ced406be93b04c7436d866d3684
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Wed Jan 2 11:14:30 2008 -0600
> 
>     [SCSI] scsi_sysfs: restore prep_fn when ULD is removed

Ah, I see.  Thanks for clarification.

Nick
-- 
Free Software Foundation Associate Member 5508
