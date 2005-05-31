From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Problem Adding Transport Class support to fusion
Date: Tue, 31 May 2005 15:38:24 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C028C5B0F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43240 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261539AbVEaVio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 17:38:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

There doesn't appear to be any aync message return
after negotiation mentioned on the mpi spec.

Look at mptscsih_doDv to see how dv nego parameters
are beeing maintained between target/initiator.
SPI Device page0/1 are read/written here.
The hd->Targets[] structure is repository of nego params.

This function was coded prior to my time on this driver, and I
haven't spent too much time trying to decipher it.

Eric Moore

On Tuesday, May 31, 2005 11:41 AM, James Bottomley wrote:
> 
> 
> Well ... I seem to have got parameter getting and setting working just
> about OK (modulo a few coupling issues).
> 
> The fusion driver seems to have quite a big event subsystem.  Is there
> an event that will report a device transfer agreement change? (without
> this it's a bit difficult to keep track of where the device and the
> fusion core are with negotiation)
> 
> Thanks,
> 
> James
> 
> 
