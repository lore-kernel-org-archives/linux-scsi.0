From: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] hpsa: fix warning with smp_processor_id() in
 preemptible
Date: Mon, 12 Aug 2013 09:33:32 -0400 (EDT)
Message-ID: <1290115203.630841.1376314412366.JavaMail.root@redhat.com>
References: <alpine.LFD.2.03.1307261640170.2642@tycho> <20130812131312.GF23040@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130812131312.GF23040@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org, Stephen Cameron <scameron@beardog.cce.hp.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, "Luis Claudio R. Goncalves" <lclaudio@uudg.org>, Clark Williams <williams@redhat.com>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> * John Kacur | 2013-07-26 16:42:30 [+0200]:
> 
> >Signed-off-by: John Kacur <jkacur@redhat.com>
> >Acked-by: Stephen <scameron@beardog.cce.hp.com>
> 
> ping.
> 
> I checked the branches for-next, scsi-fixes, fixes and misc at [0] and I
> didn't see it. I'm going to take this for 3.10-rt but please don't lose
> it on its way to Linus :)
> 
> [0] git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git


I hope it was clear to everyone that this patch was intended for upstream.
It was discovered by running the real-time kernel, but it exposes a (minor) problem
that should be fixed in the mainline kernel. Please apply it there Stephen, and
push it upstream appropriately.

Thank You.

John Kacur
