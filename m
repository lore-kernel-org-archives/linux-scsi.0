From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Tue, 31 Oct 2006 15:51:32 -0500
Message-ID: <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
References: <200610291945.16948.toralf.foerster@gmx.de>
	 <20061029190357.98fc9c98.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0610301206240.6761@scrub.home>
	 <20061030083230.5e889415.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49300 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1423627AbWJaUvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 15:51:51 -0500
In-Reply-To: <20061030083230.5e889415.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Mon, 2006-10-30 at 08:32 -0800, Randy Dunlap wrote:
> > I guess, that needs a dependency on NET.

Actually, my first thought is that the select should give us an implied
NET dependency, since the thing we've selected depends on NET.

However, if that's impossible in the Kbuild system, we should eliminate
the dependency duplication and simply make SCSI_ISCSI_ATTRS depend on
SCSI but select NET.  That will avoid this problem for any other
attribute users in future.

James


