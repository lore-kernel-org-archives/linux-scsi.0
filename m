From: "Brian Eng" <brian@midstream.com>
Subject: RE: Fusion-MPT with 53C1030 and no flash?
Date: Fri, 8 Oct 2004 17:54:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BBB2B829DCAA204D9BA39DAE37CD05A1630FEF@mail01.midstream.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.249.13.147] ([65.249.13.147]:6822 "EHLO
	seminoles.midstream.com") by vger.kernel.org with ESMTP
	id S266352AbUJIAyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2004 20:54:23 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

Matt,

I've not done it with the 53C1030, but I have done it (outside of Linux)
with the 929 & 929X FC chips.  For that, the same firmware file was used
as for writing to flash.  I think the details of how were given under
NDA, so I can't get specific (as I recall, it involved knowing some of
the address map, which is probably different on the 53C1030 anyways).
So you probably need to talk to LSI about it.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Matthew Dharm
Sent: Friday, October 08, 2004 12:57 PM
To: Linux SCSI list
Subject: Fusion-MPT with 53C1030 and no flash?

Has anyone ever used an LSI 53C1030 chip WITHOUT attached flash?

As I read the technical docs, it's possible... but it requires a driver
which can download the firmware to the ARM processor.  It looks like the
current 2.6.x driver can't do that.

In fact, I can't seem to locate a suitable firmware image anywhere...

Does anyone have any experience in this area they could share?

Matt

-- 
Matthew Dharm                              Home:
mdharm-usb@one-eyed-alien.net 
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998
