From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Thu, 02 Nov 2006 06:57:59 +0900
Message-ID: <1162418279.3612.7.camel@mulgrave.il.steeleye.com>
References: <200610291945.16948.toralf.foerster@gmx.de>
	 <20061029190357.98fc9c98.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0610301206240.6761@scrub.home>
	 <20061030083230.5e889415.randy.dunlap@oracle.com>
	 <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0611010057111.6242@scrub.home>
	 <1162394814.13859.100.camel@mulgrave.il.steeleye.com>
	 <20061101153623.GF11399@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:28329 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752504AbWKAV6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Nov 2006 16:58:19 -0500
In-Reply-To: <20061101153623.GF11399@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Roman Zippel <zippel@linux-m68k.org>, Randy Dunlap <randy.dunlap@oracle.com>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Wed, 2006-11-01 at 08:36 -0700, Matthew Wilcox wrote:
> On Thu, Nov 02, 2006 at 12:26:54AM +0900, James Bottomley wrote:
> > On Wed, 2006-11-01 at 01:00 +0100, Roman Zippel wrote:
> > > Please don't select NET, it's way too broad.
> > 
> > Then you'll make select implied dependencies work in Kbuild so we don't
> > need to do anything at all about this?
> 
> This is iSCSI ... how can it possibly be useful without NET?  Why
> doesn't CONFIG_ISCSI depend on NET, making this whole problem moot (for
> now).

Actually, no, this is a hardware iSCSI card thats using the iSCSI
transport attributes so it presents the same appearance as the software
iSCSI stack.  The card itself and its driver have no net dependency.
We're getting the NET dependency from the use of the netlink transport
in iSCSI.  Ironically, we also have a corresponding NET dependency in FC
as well, again because of netlink.

James


