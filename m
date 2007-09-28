From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Fri, 28 Sep 2007 10:22:16 +0200
Message-ID: <200709281022.17322.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:49770 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbXI1IVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 04:21:12 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Donnerstag 27 September 2007 schrieb Alan Stern:
> Have you thought about how autoresume would fit into this picture? =A0=
I
> don't think you can rely on usb-storage telling the SCSI core to resu=
me
> devices when it gets handed a command, because the commands to spin-u=
p
> the drives would have to be transmitted first. =A0(The sample patch y=
ou

Actually, it is not a big question. By default sd_resume() is a nop.
Usually the first SCSI command would return NOT_READY and SCSI core
do a START_STOP_UNIT only then in response.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
