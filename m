From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Megaraid driver fixes
Date: Tue, 16 Mar 2004 09:58:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC478@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23461 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262271AbUCPO6x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 09:58:53 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Paul Wagland' <paul@kungfoocoder.org>, Linux mailing list SCSI <linux-scsi@vger.kernel.org>
Cc: James.Bottomley@HansenPartnership.com, "Mukker, Atul" <Atulm@lsil.com>

Paul,

We are in advanced stage of code finalization  for this driver. Hopefully,
there would a code-drop before end of this week. From that point onwards, we
will work with the lists to integrate the driver in 2.6.

Thanks
-Atul Mukker
LSI Logic Corporation

> -----Original Message-----
> From: Paul Wagland [mailto:paul@kungfoocoder.org]
> Sent: Tuesday, March 16, 2004 3:42 AM
> To: Linux mailing list SCSI
> Cc: James.Bottomley@HansenPartnership.com; Atul Mukker
> Subject: Megaraid driver fixes
> 
> 
> Hi all,
> 
> As was mentioned a few weeks ago by Atul Mukker, LSI are working on a 
> new and improved driver for the megaraid cards that will, 
> amongst other 
> things, also have proper 32/64 bit support, and be fully updated.
> 
> My questions are:
> 
> Given that the changes are fairly major, what is the timeline for 
> integration of these fixes?
> 
> Is it still worth my time to try and update the current 2.6 driver up 
> to a similar level as the driver that is currently in 2.4?
> 
> Is there any other way that I can help to get this new driver 
> integrated/tested earlier? I have a SATA-RAID6 controller and 
> an AMD64 
> so am quite interested in getting that combination to work :-)
> 
> Cheers,
> Paul
> 
