From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.26-rc2
Date: Tue, 13 May 2008 13:04:27 -0500
Message-ID: <1210701867.3077.59.camel@localhost.localdomain>
References: <1210699209.3077.38.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805131051510.3019@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760303AbYEMSEn@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0805131051510.3019@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-05-13 at 10:54 -0700, Linus Torvalds wrote:
> 
> On Tue, 13 May 2008, James Bottomley wrote:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> >  [ ... ]
> > The diffstat is:
> > 
> >  aha152x.c  |    8 ++++----
> >  gdth.c     |   51 ++++++++++++++++++++++++++++++++++-----------------
> >  libiscsi.c |   29 +++++++++++++++--------------
> >  qla1280.c  |    4 ++--
> >  4 files changed, 55 insertions(+), 37 deletions(-)
> 
> I'm getting something totally different:
> 
> 	 29 files changed, 1954 insertions(+), 1672 deletions(-)
> 
> with a shortlog of
> 
> 	Chandra Seetharaman (8):
> 	      [SCSI] scsi_dh: add infrastructure for SCSI Device Handlers
> 	      [SCSI] scsi_dh: add lsi rdac device handler
> 	      [SCSI] scsi_dh: add EMC Clariion device handler
> 	      [SCSI] scsi_dh: Use SCSI device handler in dm-multipath
> 	      [SCSI] scsi_dh: Add a single threaded workqueue for initializing paths
> 	      [SCSI] scsi_dh: Remove dm_pg_init_complete
> 	      [SCSI] scsi_dh: Remove hardware handlers from dm
> 	      [SCSI] scsi_dh: Remove hardware handler infrastructure from dm
> 
> 	Christof Schmitt (2):
> 	      [SCSI] zfcp: Track fabric and channel latencies provided by FCP adapter
> 	      [SCSI] zfcp: sysfs attributes for fabric and channel latencies
> 
> 	Mark Salyzyn (1):
> 	      [SCSI] aacraid: Add Power Management cards to documentation
> 
> 	Mike Christie (1):
> 	      [SCSI] scsi_dh: add hp sw device handler
> 
> which does not match your description at all.
> 
> Not pulled. What's going on?

Sorry, wrong URL.  That's the misc tree, not the rc-fixes tree.  The
correct git url is:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

That'll teach me to use cut and paste on the email URLs ...

James
