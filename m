From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mptsas problem
Date: Tue, 15 Apr 2008 11:26:22 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229FBE557@NAMAIL2.ad.lsil.com>
References: <20080414213420.GA13594@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41368 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYDOR1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2008 13:27:34 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080414213420.GA13594@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org


> Does "chip rev" mean software/firmware or an actual chip?  Is 
> there anyway
> the driver can see this and set the queue_depth to 1?
> 

When I mean chip, I'm refering to hardware.   The revision of your
chip(1064/1068/1078) is located at offset 8 in pci config space.  This
also known as PCI_CLASS_REVISION.   You can get this by using the tool
called lspci.

Eric

