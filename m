From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: megaraid: ABORTING problem
Date: Tue, 13 Apr 2004 12:01:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC521@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13260 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263605AbUDMQBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 12:01:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Paul Wagland' <paul@kungfoocoder.org>, "Mukker, Atul" <Atulm@lsil.com>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

> I was running these tests as part of a baseline to see what, if any,
> performance differences there would be with the new unified driver.
> Should this be fixed in that new driver?
The new drivers have the new error handling, so your server should still be
operative if commands start to abort.
