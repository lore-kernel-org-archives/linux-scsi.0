From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Informational Exception mpage [was: usb storage traces]
Date: 05 Dec 2003 09:02:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070640144.12411.18.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312051025560.850-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:60667 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264238AbTLEQCg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 11:02:36 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312051025560.850-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

> According to the USB Mass Storage Class - UFI Command Specification, which 
> might be more applicable in this circumstance,

Please NO!!!!!!!!!!

On this digressing point, I think all the applicable English texts
actually agree with each other and with reality.

UFI applies exclusively to usb-storage devices with the corresponding
bInterfaceSubClass.  I think I remember that is x04, not found in Win
generic x 08 (02|05|06) 50.

Personally I haven't yet had to grok UFI.  I could choose instead to
study only ANSI T10 SCSI and SFF SCSI and USB Bootable SCSI.  Each of
those have dozens of subflavours.  I don't want to have to start
studying a fourth major flavour as yet confined only to USB1FS CBI/CB
FDD, though rumoured to be coming to USB2HS BBB.

Pat LaVarre


