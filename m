From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: How to generate ILI condtion on a tape device
Date: Mon, 24 Nov 2003 09:31:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC1C1F1.13720A16@fujitsu-siemens.com>
References: <1069489007.3775.15.camel@driver>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plim.fujitsu-siemens.com ([217.115.66.8]:63795 "EHLO
	plim.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S263646AbTKXIbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2003 03:31:14 -0500
List-Id: linux-scsi@vger.kernel.org
To: Kallol Biswas <nucleodyne@comcast.net>
Cc: linux-scsi@vger.kernel.org

> Kallol Biswas wrote:
>=20
> Hi,
>   I was wondering how to generate ILI condition while reading from a
> tape.

IIRC all you need is a tape with variable block size and you just read
the wrong blocksize.


Josef
--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
