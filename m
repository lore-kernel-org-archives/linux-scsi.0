From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.26-rc2
Date: Tue, 13 May 2008 10:54:05 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0805131051510.3019@woody.linux-foundation.org>
References: <1210699209.3077.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbYEMRyj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2008 13:54:39 -0400
In-Reply-To: <1210699209.3077.38.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Tue, 13 May 2008, James Bottomley wrote:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>  [ ... ]
> The diffstat is:
> 
>  aha152x.c  |    8 ++++----
>  gdth.c     |   51 ++++++++++++++++++++++++++++++++++-----------------
>  libiscsi.c |   29 +++++++++++++++--------------
>  qla1280.c  |    4 ++--
>  4 files changed, 55 insertions(+), 37 deletions(-)

I'm getting something totally different:

	 29 files changed, 1954 insertions(+), 1672 deletions(-)

with a shortlog of

	Chandra Seetharaman (8):
	      [SCSI] scsi_dh: add infrastructure for SCSI Device Handlers
	      [SCSI] scsi_dh: add lsi rdac device handler
	      [SCSI] scsi_dh: add EMC Clariion device handler
	      [SCSI] scsi_dh: Use SCSI device handler in dm-multipath
	      [SCSI] scsi_dh: Add a single threaded workqueue for initializing paths
	      [SCSI] scsi_dh: Remove dm_pg_init_complete
	      [SCSI] scsi_dh: Remove hardware handlers from dm
	      [SCSI] scsi_dh: Remove hardware handler infrastructure from dm

	Christof Schmitt (2):
	      [SCSI] zfcp: Track fabric and channel latencies provided by FCP adapter
	      [SCSI] zfcp: sysfs attributes for fabric and channel latencies

	Mark Salyzyn (1):
	      [SCSI] aacraid: Add Power Management cards to documentation

	Mike Christie (1):
	      [SCSI] scsi_dh: add hp sw device handler

which does not match your description at all.

Not pulled. What's going on?

		Linus
