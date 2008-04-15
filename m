From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mptsas problem
Date: Tue, 15 Apr 2008 18:49:49 -0400
Message-ID: <20080415224949.GA9155@animx.eu.org>
References: <20080414213420.GA13594@animx.eu.org> <0631C836DBF79F42B5A60C8C8D4E8229FBE557@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:42589 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbYDOWuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2008 18:50:07 -0400
Content-Disposition: inline
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229FBE557@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

Moore, Eric wrote:
> 
> > Does "chip rev" mean software/firmware or an actual chip?  Is 
> > there anyway
> > the driver can see this and set the queue_depth to 1?
> 
> When I mean chip, I'm refering to hardware.   The revision of your
> chip(1064/1068/1078) is located at offset 8 in pci config space.  This
> also known as PCI_CLASS_REVISION.   You can get this by using the tool
> called lspci.

04:02.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X
Fusion-MPT SAS (rev 01)
00: 00 10 54 00 56 01 30 02 01 00 00 01 08 48 00 00
10: 01 50 00 00 04 00 41 d8 00 00 00 00 04 00 40 d8
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 10 30 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 40 0a
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 98 02 06 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 07 b0 60 10 10 04 43 13
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 05 68 80 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 11 00 00 00 01 20 00 00 01 30 00 00 00 00 00 00

I'm not that familiar with the pci config space.  Are you saying that I need
a new chip for the new firmware?  If so, considering everything is soldered
on the board, I'd have a hard time replacing it!  =)

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
