From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Thu, 02 Nov 2006 00:26:54 +0900
Message-ID: <1162394814.13859.100.camel@mulgrave.il.steeleye.com>
References: <200610291945.16948.toralf.foerster@gmx.de>
	 <20061029190357.98fc9c98.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0610301206240.6761@scrub.home>
	 <20061030083230.5e889415.randy.dunlap@oracle.com>
	 <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0611010057111.6242@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:23777 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S2992611AbWKAP1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Nov 2006 10:27:41 -0500
In-Reply-To: <Pine.LNX.4.64.0611010057111.6242@scrub.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Wed, 2006-11-01 at 01:00 +0100, Roman Zippel wrote:
> Please don't select NET, it's way too broad.

Then you'll make select implied dependencies work in Kbuild so we don't
need to do anything at all about this?

James


