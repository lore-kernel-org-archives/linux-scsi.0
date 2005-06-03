From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Fri, 3 Jun 2005 11:35:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506031126510.6451-100000@iolanthe.rowland.org>
References: <1117812062.5030.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:1433 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261329AbVFCPf0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2005 11:35:26 -0400
In-Reply-To: <1117812062.5030.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 3 Jun 2005, James Bottomley wrote:

> On Wed, 2005-06-01 at 17:26 -0400, Alan Stern wrote:
> > By the way, is scsi-misc available anywhere as a patch (or set of
> > patches) for those of us not on the bleeding edge, or does it exist only 
> > as a git repository?
> 
> I suppose I should have a cron job sending this information to linux-
> scsi weekly ...
> 
> The git repositories are:
> 
> rsync://www.parisc-linux.org/~jejb/git/scsi-misc-2.6.git
> rsync://www.parisc-linux.org/~jejb/git/scsi-rc-fixes-2.6.git
> 
> There's a browser for the git tree at
> 
> http://www.parisc-linux.org/cgi-bin/gitweb.pl
> 
> And the patches and change logs are here
> 
> http://www.parisc-linux.org/~jejb/scsi_diffs
> 
> I'm also in the process of setting up SCSI git trees on www.kernel.org

Sorry -- it's my fault for not subscribing to linux-scsi (I don't post to 
it very often).  Thanks for the pointers.

Alan Stern

