From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Megaraid and Linux 2.6 questions
Date: Tue, 6 Apr 2004 00:49:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC4F1@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52187 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263617AbUDFEt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 00:49:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Paul Wagland' <paul@wagland.net>, Linux SCSI mailing list <linux-scsi@vger.kernel.org>
Cc: "Mukker, Atul" <Atulm@lsil.com>

The two driver model, as suggested by many people on the list, put some
unique conditions in the driver. The driver for most parts is complete and
currently undergoing the our development testing.

I promised a release some weeks ago but we could not make it because of
stability issues. But it is in much better shape now and would be available
for review pretty soon.

-Atul Mukker

-----Original Message-----
From: Paul Wagland [mailto:paul@wagland.net]
Sent: Monday, April 05, 2004 5:25 PM
To: Linux SCSI mailing list
Cc: Atul Mukker
Subject: Megaraid and Linux 2.6 questions


Hi all,

One question, one problem:

question: What is the current status of the unified driver for 2.6?

problem: When using dellmgr v 5.31 to delete a logical drive on my
SATA-150-6 board under linux 2.6.4, the controller seems to hang. I can
continue to do stuff, so long as I don't want to touch that controller.
As this is my only IO controller that is a little tricky :-) Has thyis
problem been seen before? Is there a known workaround?

Cheers,
Paul
