From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Tue, 31 Oct 2006 13:13:27 -0800
Message-ID: <4547BC77.1020909@oracle.com>
References: <200610291945.16948.toralf.foerster@gmx.de>	 <20061029190357.98fc9c98.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0610301206240.6761@scrub.home>	 <20061030083230.5e889415.randy.dunlap@oracle.com>	 <1162327892.13859.67.camel@mulgrave.il.steeleye.com>	 <4547B6D5.1050208@oracle.com>	 <1162328587.13859.71.camel@mulgrave.il.steeleye.com>	 <4547B9E3.4070307@oracle.com> <1162329179.13859.76.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:11516 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1946014AbWJaVR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 16:17:59 -0500
In-Reply-To: <1162329179.13859.76.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

James Bottomley wrote:
> On Tue, 2006-10-31 at 13:02 -0800, Randy Dunlap wrote:
>> I suppose that means that you had rather stick with 'select'
>> intead of use 'depends' ?
> 
> Yes ... if we're going to use a config option as a select, I want it not
> to have hidden dependencies ... and if that means the option itself
> needs an additional select (like select NET in this case) then so be it.

OK, I guess that's clear enough.

I'd rather just eliminate the select usage, but whatever.

Thanks,
-- 
~Randy
