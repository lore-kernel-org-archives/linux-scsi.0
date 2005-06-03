From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Fri, 03 Jun 2005 10:21:02 -0500
Message-ID: <1117812062.5030.21.camel@mulgrave>
References: <Pine.LNX.4.44L0.0506011708410.5912-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:43183 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261323AbVFCPVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2005 11:21:25 -0400
In-Reply-To: <Pine.LNX.4.44L0.0506011708410.5912-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2005-06-01 at 17:26 -0400, Alan Stern wrote:
> By the way, is scsi-misc available anywhere as a patch (or set of
> patches) for those of us not on the bleeding edge, or does it exist only 
> as a git repository?

I suppose I should have a cron job sending this information to linux-
scsi weekly ...

The git repositories are:

rsync://www.parisc-linux.org/~jejb/git/scsi-misc-2.6.git
rsync://www.parisc-linux.org/~jejb/git/scsi-rc-fixes-2.6.git

There's a browser for the git tree at

http://www.parisc-linux.org/cgi-bin/gitweb.pl

And the patches and change logs are here

http://www.parisc-linux.org/~jejb/scsi_diffs

I'm also in the process of setting up SCSI git trees on www.kernel.org

James


