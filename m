From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Tue, 31 Oct 2006 12:49:25 -0800
Message-ID: <4547B6D5.1050208@oracle.com>
References: <200610291945.16948.toralf.foerster@gmx.de>	 <20061029190357.98fc9c98.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0610301206240.6761@scrub.home>	 <20061030083230.5e889415.randy.dunlap@oracle.com> <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:42044 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1423626AbWJaUyB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 15:54:01 -0500
In-Reply-To: <1162327892.13859.67.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

James Bottomley wrote:
> On Mon, 2006-10-30 at 08:32 -0800, Randy Dunlap wrote:
>>> I guess, that needs a dependency on NET.
> 
> Actually, my first thought is that the select should give us an implied
> NET dependency, since the thing we've selected depends on NET.

Agreed.  :(

> However, if that's impossible in the Kbuild system, we should eliminate
> the dependency duplication and simply make SCSI_ISCSI_ATTRS depend on
> SCSI but select NET.  That will avoid this problem for any other
> attribute users in future.

I'd prefer to avoid the use of 'select' if at all possible.

-- 
~Randy
