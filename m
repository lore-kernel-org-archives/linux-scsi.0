From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Fri, 21 Aug 2009 10:04:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908211003090.2912-100000@iolanthe.rowland.org>
References: <20090820220740.GA767@ime.usp.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43309 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754626AbZHUOE1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 10:04:27 -0400
In-Reply-To: <20090820220740.GA767@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org

On Thu, 20 Aug 2009, [utf-8] Rog=C3=A9rio Brito wrote:

> Again, just reiterating, what I said before, even though I am not sur=
e
> if I can reproduce it, I will try to.

A usbmon trace showing what happens when you plug in the drive and=20
when you run smartctl would help.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
