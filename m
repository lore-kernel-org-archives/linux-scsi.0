From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] hpsa: fix warning with smp_processor_id() in
 preemptible
Date: Mon, 12 Aug 2013 15:13:12 +0200
Message-ID: <20130812131312.GF23040@linutronix.de>
References: <alpine.LFD.2.03.1307261640170.2642@tycho>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1307261640170.2642@tycho>
Sender: linux-kernel-owner@vger.kernel.org
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org, Stephen Cameron <scameron@beardog.cce.hp.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, "Luis Claudio R. Goncalves" <lclaudio@uudg.org>, Clark Williams <williams@redhat.com>
List-Id: linux-scsi@vger.kernel.org

* John Kacur | 2013-07-26 16:42:30 [+0200]:

>Signed-off-by: John Kacur <jkacur@redhat.com>
>Acked-by: Stephen <scameron@beardog.cce.hp.com>

ping.

I checked the branches for-next, scsi-fixes, fixes and misc at [0] and I
didn't see it. I'm going to take this for 3.10-rt but please don't lose
it on its way to Linus :)

[0] git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git

Sebastian
