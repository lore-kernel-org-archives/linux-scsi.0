From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: megaraid: ABORTING problem
Date: Tue, 13 Apr 2004 11:09:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC51F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:24251 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263596AbUDMPKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 11:10:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Paul Wagland' <paul@kungfoocoder.org>, Linux SCSI mailing list <linux-scsi@vger.kernel.org>

 > In trying to do some performance analysis on my LSI Login 
> SATA-150-6, I
> 
> megaraid: ABORTING-188cf36 cmd=2a <c=0 t=5 l=0>
> megaraid: ABORTING-188cf36[52], fw owner.
>
You seem to be running a older version of the driver. Can you upgrade to the
latest 2.10.3 or 2.20.x.x and re-test. Also, what is the firmware version on
this controller.

-Atul Mukker
