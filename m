From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: Can't eject jaz disk on 2.6
Date: Mon, 29 Mar 2004 08:40:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <728F2ABA-8197-11D8-AECB-003065635034@ieee.org>
References: <20040327075918.A2232@animx.eu.org><20040327224222.GA5203@one-ey
	 ed-alien.net> <20040327180018.A4269@animx.eu.org><20040327225258.GB5203@on
	e -eyed-alien.net> <20040327190746.A4500@animx.eu.org>
Mime-Version: 1.0 (Apple Message framework v612)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:31409 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262983AbUC2PmU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 10:42:20 -0500
In-Reply-To: <20040327190746.A4500@animx.eu.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Wakko Warner <wakko@animx.eu.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>

The SCSI jaz 1GB interpretation of ops x1B/ x1E matches the USB/ ATAPI 
zip handling, as I mis/remember its 1995-11 release.  I'd love to hear 
more concrete proof, if an apparent difference exists.

jaz 2GB could but should not differ from jaz 1GB: released from Iomega 
San Jose rather than from Iomega Utah.  USB jaz could but should not 
differ from SCSI 1GB: bridged to USB from SCSI by some third party, 
perhaps then resold by Iomega.  PPT/ SCSI Bernoulli/ zip we know 
differs from USB/ ATAPI zip/ jaz because the PPT/ SCSI zip design is 
old enough to remind us that t10.org grew the pdt x 00/ 06/ 07 op x1B 
definition incompatibly in SCSI-2, vs. the not-available-gratis SCSI-1.

Pat LaVarre

