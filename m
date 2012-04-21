From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] libsas fixes for 3.4-rc4
Date: Sat, 21 Apr 2012 13:28:56 +0100
Message-ID: <1335011336.3081.12.camel@dabdike.lan>
References: <1334960945.21447.19.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1334960945.21447.19.camel@ultramagnus.opencreations.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, jack_wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-04-20 at 15:29 -0700, Dan Williams wrote:
> These patches, save for the new "scsi: fix eh wakeup (scsi_schedule_eh
> vs scsi_restart_operations)" and "Revert "[SCSI] libsas: fix sas port
> naming", were all originally posted before the merge
> window opened, and have also appeared in -next for the same timeframe.
> 
> The commit dates are not that aged (9 days old) because they were
> rebased out of larger set of updates that were pending for 3.4.
> 
> There is a mix of pure regression fixes and fixes for long-standing bugs
> in libsas.  Some of the long-standing bug fixes are made worse / easier
> to trigger by the new async error handling scheme.
> 
> The largest patch in the series is "libata, libsas: introduce sched_eh
> and end_eh port ops" it has been on the list since March 10th.
> 
> Jack Wang has independently tested this set with pm8001 and reports
> success. [1]
> 
> Apologies if scsi-rc-fixes was in the process of picking these up.  With
> -rc4 looming I lost my nerve and pulled the trigger.

Right, so as a point of process, these are SCSI fixes and are supposed
to be going through the SCSI tree.  The only urgent one is the revert; I
still have outstanding questions about some of the others.

We're at least 3 weeks away from 3.4 (and that's only if -rc6 is final),
so there's time to address all of this via the usual process.

James


