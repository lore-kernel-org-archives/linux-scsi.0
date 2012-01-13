From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
Date: Fri, 13 Jan 2012 15:02:39 -0800
Message-ID: <1326495759.30987.77.camel@haakon2.linux-iscsi.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-01-10 at 10:56 -0800, Nicholas A. Bellinger wrote:
> Hi Linus,
> 
> The following are the v3.3-rc1 merge window updates for the target
> subsystem.  The series has been in linux-next since before the holiday
> break, and can be pulled directly from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge
> 
> The series has been cut against the following mainline commit:
> 
> commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Dec 9 15:09:32 2011 -0800
> 
>     Linux 3.2-rc5
> 
> The main highlights include:
> 
> *) Initial merge for the SRP target (ib_srpt) fabric module (bart)
> *) Restructuring of target private + public target headers (hch)
> *) Addition of target_submit_cmd() for fabrics (hch + nab)
> *) Conversion of tcm_fc to use target_submit_cmd() (nab)
> *) Remove legacy se_device TCQ depth handling (nab)
> *) Remove extra se_device->execute_task_lock is fast path (nab)
> *) Set missing additional sense length field (roland)
> 
> Please let us know if you have any questions.
> 

Hi Linus,

Just a friendly ping on this pull request for -rc1.  Please go ahead and
pull at your earliest convenience, and let us know if you have any
questions or concerns.

Thank you,

--nab
