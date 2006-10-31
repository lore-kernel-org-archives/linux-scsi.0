From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Tue, 31 Oct 2006 16:12:58 -0500
Message-ID: <1162329179.13859.76.camel@mulgrave.il.steeleye.com>
References: <200610291945.16948.toralf.foerster@gmx.de>
	 <20061029190357.98fc9c98.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0610301206240.6761@scrub.home>
	 <20061030083230.5e889415.randy.dunlap@oracle.com>
	 <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
	 <4547B6D5.1050208@oracle.com>
	 <1162328587.13859.71.camel@mulgrave.il.steeleye.com>
	 <4547B9E3.4070307@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59300 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1423646AbWJaVNR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 16:13:17 -0500
In-Reply-To: <4547B9E3.4070307@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Tue, 2006-10-31 at 13:02 -0800, Randy Dunlap wrote:
> I suppose that means that you had rather stick with 'select'
> intead of use 'depends' ?

Yes ... if we're going to use a config option as a select, I want it not
to have hidden dependencies ... and if that means the option itself
needs an additional select (like select NET in this case) then so be it.

James


