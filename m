From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Sun, 15 Jan 2017 08:11:05 -0800
Message-ID: <1484496665.2405.2.camel@HansenPartnership.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
         <20170115091925.GA26656@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170115091925.GA26656@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2017-01-15 at 10:19 +0100, Ingo Molnar wrote:
> So there's a new mpt3sas SCSI driver boot regression, introduced in 
> this merge window, which made one of my servers unbootable.

We're not reverting a fix that would cause regressions for others. 
 However, The fix was manifestly wrong, so does this fix of the fix
work for you:

http://marc.info/?l=linux-scsi&m=148329237807604

It's been languishing a bit because no-one seemed to care enough to
test or review it.  IOf you can add a tested by, that will give the two
we need to push it.

James
