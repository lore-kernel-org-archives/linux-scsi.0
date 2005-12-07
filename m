From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Wed, 7 Dec 2005 18:56:04 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512071844560.3335@goblin.wat.veritas.com>
References: <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <20051201195657.GB7236@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
 <20051202180326.GB7634@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512021856170.4940@goblin.wat.veritas.com>
 <20051202194447.GA7679@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512022037230.6058@goblin.wat.veritas.com>
 <20051206160815.GC11560@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512062025230.28217@goblin.wat.veritas.com>
 <20051207183047.GA12857@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751757AbVLGS4u@vger.kernel.org>
Received: from linux.wat.veritas.com([10.10.97.50]) (2335 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1Ek4SU-0001JFC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Wed, 7 Dec 2005 10:56:06 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <20051207183047.GA12857@tau.solarneutrino.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Linus Torvalds <torvalds@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 7 Dec 2005, Ryan Richter wrote:

> I don't know if this is related, but in the last couple days I've seen
> hundreds of these messages from this machine (and I haven't seen it
> before):
> 
> Hangcheck: hangcheck value past margin!

I'm unclear whether you rebooted after the "general protection fault"
and "NMI Watchdog" messages (if you had to, I'm sure you did, but I
don't know whether the machine appeared to work on after those).

If you didn't reboot, then discount these "Hangcheck" messages as a
consequence of the earlier errors, and reboot as soon as convenient.
It's interesting for me to see the Bad page state, Bad page state,
BUG in mm.h, BUG in rmap.c; but after those you ought to reboot.

If you did reboot, well, maybe related, but it doesn't tell us much.

Hugh
