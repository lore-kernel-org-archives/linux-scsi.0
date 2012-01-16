From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Mon, 16 Jan 2012 12:40:28 +0400
Message-ID: <1326703228.2872.5.camel@dabdike>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
	 <1326223752.3264.43.camel@dabdike.int.hansenpartnership.com>
	 <CABE8wwuBN45f2s-bcW3R=5VE1V3svtcrp93-9LW5zZ6VtZFqmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwuBN45f2s-bcW3R=5VE1V3svtcrp93-9LW5zZ6VtZFqmQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jack_wang@usish.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-01-10 at 12:18 -0800, Dan Williams wrote:
> On Tue, Jan 10, 2012 at 11:29 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Mon, 2012-01-09 at 23:38 -0800, Dan Williams wrote:
> >> The latest version of the patch kit is available here:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-eh-reworks-v4
> >>
> >> Changes since v3: http://marc.info/?l=linux-scsi&m=132581455214789&w=2
> >
> > Just to check I'm not lost here. I think this is currently the only
> > mergeable set of patches you have because you're reworking patches in
> > all your other series and will repost ... is this correct?
> 
> There are two mergeable topics in isci.git:
> libsas-eh-reworks-v4: mergeable
> devel: mergeable, posted as "[GIT PATCH v2 00/15] isci update for 3.3
> (part1)" [1].  This contains all the general updates to the driver
> that were independent of the libsas churn.  It was rebased to
> incorporate Ben's firmware removal patch, but is otherwise idle and
> ready to merge.

1/2 doesn't apply:

patching file drivers/scsi/libsas/sas_scsi_host.c
Hunk #1 succeeded at 235 with fuzz 2 (offset -14 lines).
Hunk #2 FAILED at 267.
Hunk #3 succeeded at 505 with fuzz 2 (offset -25 lines).
Hunk #4 succeeded at 512 with fuzz 1 (offset -34 lines).
Hunk #5 FAILED at 655.
2 out of 5 hunks FAILED -- saving rejects to file
drivers/scsi/libsas/sas_scsi_host.c.rej

James


