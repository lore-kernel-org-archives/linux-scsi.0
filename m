From: Brad Boyer <flar@allandria.com>
Subject: Re: mac_scsi boot crash, was Re: [PATCH] m68k link error and NCR5380_exit()
Date: Tue, 8 Mar 2005 09:39:40 -0800
Message-ID: <20050308173939.GA17983@pants.nu>
References: <20050213063225.GA17415@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au> <20050213075506.GA18622@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au> <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au> <20050307063719.GA12478@infradead.org> <Pine.LNX.4.61.0503072333310.27126@loopy.telegraphics.com.au> <20050307175322.GA12907@pants.nu> <20050307234233.GA6240@excalibur.research.wombat.ie> <Pine.LNX.4.61.0503090156380.1135@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:33800
	"EHLO cynthia.pants.nu") by vger.kernel.org with ESMTP
	id S261426AbVCHRjm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2005 12:39:42 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0503090156380.1135@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Kenn Humborg <kenn@linux.ie>, linux scsi <linux-scsi@vger.kernel.org>, linux m68k <linux-m68k@vger.kernel.org>

On Wed, Mar 09, 2005 at 02:16:45AM +1100, Finn Thain wrote:
> That seems to have helped. It still crashes with the same bus error, but 
> the preceding issue/disconnect/abort cycle is gone now. Log is below. 
> Hopefully I'll get a chance to look at the bus error soon.

I notice it got through all the device identify stuff. It dies as soon
as it actually tries to tranfer a real block of data (the partition map)
and do something useful with it. Could you see if disabling PDMA helps?
There's a way to do it with the command line, but that is messy. If you
don't mind recompiling, just set the FLAG_NO_PSEUDO_DMA flag like it
always does for the IIfx case. The performance will be terrible, but
it might help narrow down the problem.

	Brad Boyer
	flar@allandria.com

