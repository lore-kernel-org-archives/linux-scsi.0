From: Mark Lord <lsml@rtr.ca>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: Tue, 05 Oct 2004 10:44:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4162B345.9000806@rtr.ca>
References: <1096401785.13936.5.camel@localhost.localdomain>	<1096467125.2028.11.camel@mulgrave> 	<20041005114951.GD22396@krispykreme.ozlabs.ibm.com> <1096984590.1765.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:2746 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S269046AbUJEOqI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 10:46:08 -0400
In-Reply-To: <1096984590.1765.2.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

There seem to be other holes/races in this and related code.

The QStor driver implements hot insertion/removal of drives.

One thing it has to cope with at present is, after notifying
the mid-layer that a drive has been removed, the mid-layer calls
back with a synchronize-cache command for that drive..

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
