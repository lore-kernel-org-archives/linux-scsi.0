From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Fri, 28 Sep 2007 11:04:48 +0200
Message-ID: <200709281104.48673.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:49276 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbXI1JDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 05:03:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Donnerstag 27 September 2007 schrieb Alan Stern:
> There's also a philosophical objection. =A0Who is in a better positio=
n to
> judge when a device like a SCSI drive should be autosuspended: its ow=
n
> driver (sd) or someone else (usb-storage)?

Then a philosophical answer. The highest entity which understands what
it is doing when using power management. Highest here to be understood
not as a position in the device tree, but in the flow of information.

That is in our case usb-storage. Sr or sd can't do it because they don'=
t
and can't understand power management.
Now they might be asked to provide some helpers. An open count and
notifications about the state of the queue would be obvious. Other
suggestions?

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
