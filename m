From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Serial Attached SCSI Driver Interface (SDI)
Date: Mon, 15 Nov 2004 12:48:45 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B5C0F3D@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:16096 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261647AbUKORst convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 12:48:49 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Tuikov, Luben" <Luben_Tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

CSMI is an ioctl mechanism. Have incorporated this interface into my
working version of the driver. Duplication is already showing, witness
Eric Moore's (rejected) submission.

The T10 document Luben refers to, is to start the groundwork and does
not list any specific interface yet. March 2006 is the `public release
data' ... Get your comments in now!

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
Sent: Monday, November 15, 2004 12:40 PM
To: Tuikov, Luben
Cc: SCSI Mailing List
Subject: Re: Serial Attached SCSI Driver Interface (SDI)

Luben Tuikov wrote:
> I think it would be a good thing:
> 
> ftp://ftp.t10.org/t10/document.04/04-345r1.pdf
> 
>     Luben
> 
> P.S. CSMI...

What sort of interface is this?

Hardware interface?  Software-based (ioctl) interface?

	Jeff



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
