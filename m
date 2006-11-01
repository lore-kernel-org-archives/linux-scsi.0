From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Wed, 01 Nov 2006 17:18:40 +0100
Message-ID: <1162397920.23744.28.camel@laptopd505.fenrus.org>
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
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:31650 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S1946921AbWKAQTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Nov 2006 11:19:04 -0500
In-Reply-To: <20061101153623.GF11399@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Roman Zippel <zippel@linux-m68k.org>, Randy Dunlap <randy.dunlap@oracle.com>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

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

I doubt ANYONE runs without NET; just WAY too much stuff breaks (not
even unix sockets work!)
