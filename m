From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 11:22:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068747746.16444.30.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
	 <1068744259.13580.41.camel@patrh9>
	 <20031113100424.A26197@beaverton.ibm.com>
	 <1068747355.16444.22.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:60599 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264387AbTKMSXD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 13:23:03 -0500
In-Reply-To: <1068747355.16444.22.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> Is this ...?

Oi.

Here we have bInterfaceSubClass = xFF.

That's this device TELLING US THIS DEVICE DOES NOT TALK SCSI.

We shouldn't be surprised to discover this device then indeed does not
talk SCSI?

How about we blacklist all the bInterfaceSubClass that Windows does not
regard as generic.  I remember Windows does regard bInterfaceSubClass =
x06 as generic.  I think I remember there are two others.  Please stay
tuned for a moment.  Meanwhile,

> ...

At length ...

This device does NOT describe itself as generic e.g. not much like x 08
06 50 = MassStorage SCSI BBB.

We may not even have the Windows CBI/CB driver here?

Are we observing a Windows driver from a vendor other than Microsoft?

I see:

    bDeviceClass       : 0x00 (0)
    bDeviceSubClass    : 0x00 (0)
    bDeviceProtocol    : 0x00 (0)
...

  InterfaceNumber: 0x00
...

  Class             = 0x34
  SubClass          = 0x6d
  Protocol          = 0x37
...

  InterfaceNumber: 0x00
...

  Class             = 0x08
  SubClass          = 0xff
  Protocol          = 0x01

I'm guessing that SubClass lines means we have bInterfaceClass
...SubClass ...Protocol = x 08 FF 01.

Pat LaVarre


