From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: 12 Sep 2003 13:18:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063394289.3677.48.camel@patehci2>
References: <Pine.LNX.4.44L0.0309111551410.2667-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:29334 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261838AbTILTRJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 15:17:09 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309111551410.2667-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: patmans@us.ibm.com, mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


> From: Alan Stern <stern@rowland.harvard.edu>
>
> the MODE SENSE page 0x3f (to check the write
> protect) ... (I haven't seen ... problems,
> but others have.)

I imagine page x3F is an sd issue only?

I remember Ansi says the mode sense header reports writability only for
pdt x00 hdd.

I remember pdt x05 dvd/cd devices misbehaving when their available x3f
AllPages data exceeded the xFF bytes that x1A MODE_SENSE can copy,
though x5A MODE_SENSE_10 worked fine.

And I often repeat, I remember clearly that the popular OS doesn't often
ask only for a four-byte x1A MODE_SENSE header, because I saw that
actually doing that crashes Win 2K kernels up thru SP3, if Windows has
concluded the device needs the host to translate to x5A MODE_SENSE_10.

Pat LaVarre



