From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: adding flag for 192 byte mode sense
Date: 16 Mar 2004 13:27:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079468821.20754.35.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0403161505060.5945-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:24204 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261644AbUCPU3Z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 15:29:25 -0500
In-Reply-To: <Pine.LNX.4.44L0.0403161505060.5945-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>

> With my USB CDRW drive, Windows 2000 issued x5a = MODE SENSE(10).  It did
> so even though the class/protocol/subclass are 08/50/06.  Furthermore,
> testing with usb-storage showed that the drive doesn't accept MODE
> SENSE(6).

Yes, per spec.  That is:

t10.org mmc4r02h.pdf "Table 213" "Commands ... (Opcode order)" shows no
definition for the response of a PDT x05 DVD/ CD drive to an assault of
PDT x00 SBC ops x1A/ 5A Mode Sense/ Select (6).

t10.org spc2r20.pdf "Table 13" "Commands for all device types" via code
"Z" gives this rude freedom to MMC: "Command implementation is"
peripheral "device type specific".

Pat LaVarre


