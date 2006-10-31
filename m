From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Tue, 31 Oct 2006 16:03:06 -0500
Message-ID: <1162328587.13859.71.camel@mulgrave.il.steeleye.com>
References: <200610291945.16948.toralf.foerster@gmx.de>
	 <20061029190357.98fc9c98.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0610301206240.6761@scrub.home>
	 <20061030083230.5e889415.randy.dunlap@oracle.com>
	 <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
	 <4547B6D5.1050208@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:22684 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1945993AbWJaVDW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 16:03:22 -0500
In-Reply-To: <4547B6D5.1050208@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Tue, 2006-10-31 at 12:49 -0800, Randy Dunlap wrote:
> I'd prefer to avoid the use of 'select' if at all possible.

But given that we do use it, I'd prefer it to come without having to
work out what the strings of implied dependencies are.  We only use it
for enabling our infrastructure pieces (i.e. we want to present a
Parallel HBA choice, but if it requires the SPI transport class we don't
want the user to not select that and then wonder why they're not seeing
the HBA driver they need, hence the HBA will select the transport
class).

James


