From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Wed, 28 Mar 2012 10:41:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203281033520.1599-100000@iolanthe.rowland.org>
References: <798989.59139.qm@web100013.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34396 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752269Ab2C1OlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2012 10:41:04 -0400
In-Reply-To: <798989.59139.qm@web100013.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 28 Mar 2012, Norman Diamond wrote:

> I don't want to manhandle that old notebook's fragile vendor propriet=
ary IDE cable again, but I'll try to find another way to test that driv=
e again without going though USB.

You don't have to worry about that.  sg_dd works fine over USB.

> > The USB-to-IDE bridge is vendor 067b, product 2507, Prolific Techno=
logy Inc., and usb-storage matches it for quirk 110.

What is the bcdDevice value?

> > Digression:=EF=BF=BD Someone adjusts the number of blocks from the =
reported 39070080 (which I think is correct) to 39070079 (which I think=
 is wrong).=EF=BF=BD I'll have to install the drive in an old notebook =
to check if the reported number=20
of blocks is really correct.
>=20
> Further on this digression:  The number of blocks really is 39070080.=
  Today libata made no adjustment and the number of blocks was correct.=
  So some USB component makes a misadjustment to screw up the number of=
 blocks.

usb-storage does this, because in the past Prolific's bridges have=20
reported the wrong number of blocks.  In fact, I'm surprised that it=20
seems to work correctly with your drive.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
