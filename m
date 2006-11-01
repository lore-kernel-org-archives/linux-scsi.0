From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Wed, 1 Nov 2006 01:00:57 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611010057111.6242@scrub.home>
References: <200610291945.16948.toralf.foerster@gmx.de>
 <20061029190357.98fc9c98.randy.dunlap@oracle.com>  <Pine.LNX.4.64.0610301206240.6761@scrub.home>
  <20061030083230.5e889415.randy.dunlap@oracle.com>
 <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:49281 "EHLO scrub.xs4all.nl")
	by vger.kernel.org with ESMTP id S1946187AbWKAABZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 19:01:25 -0500
In-Reply-To: <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

Hi,

On Tue, 31 Oct 2006, James Bottomley wrote:

> On Mon, 2006-10-30 at 08:32 -0800, Randy Dunlap wrote:
> > > I guess, that needs a dependency on NET.
> 
> Actually, my first thought is that the select should give us an implied
> NET dependency, since the thing we've selected depends on NET.
> 
> However, if that's impossible in the Kbuild system, we should eliminate
> the dependency duplication and simply make SCSI_ISCSI_ATTRS depend on
> SCSI but select NET.  That will avoid this problem for any other
> attribute users in future.

Please don't select NET, it's way too broad.

bye, Roman
