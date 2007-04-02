From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx driver woes
Date: Mon, 02 Apr 2007 19:36:54 -0400
Message-ID: <46119396.3070008@torque.net>
References: <460E90F3.9070601@torque.net> <460EA211.2060501@us.ibm.com>	 <460EB110.8060706@torque.net>	 <1175383041.3760.70.camel@mulgrave.il.steeleye.com>	 <4610161D.7060709@torque.net> <1175536352.3680.52.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56972 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966108AbXDBXje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 19:39:34 -0400
In-Reply-To: <1175536352.3680.52.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2007-04-01 at 16:29 -0400, Douglas Gilbert wrote:
>> ...
>> sas: phy3 added to port0, phy_mask:0x8
>> sas: DOING DISCOVERY on port 0, pid:2110
>> aic94xx: scb:0x80 timed out
> 
> This might be the problem.
> 
> I see this periodically when a phy goes out to lunch on my system ...
> with me, it always seems to be phy0 of a port containing phy0-4 ... so
> phy1-3 still function to get messages.
> 
> Can you try sending a link reset to phy3?
> 
> It should be something like
> 
> echo 1 > /sys/class/sas_phy/phy-X:3/link_reset
> 
> and see if it just produces 
> 
> aic94xx: scb:0x80 timed out

Yes it does.

> Again?

It is repeatable.

Also when I connect to phy 0 it works (both direct
connect and expander). However phys 1 and 2 react
like phy 3 shown above.

Doug Gilbert

