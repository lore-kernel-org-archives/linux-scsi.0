From: Stefan Berder <sbe@oleane.net>
Subject: Re: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Fri, 7 Jan 2005 09:48:24 +0100
Message-ID: <20050107094824.62a1ba1b@gibson>
References: <0E3FA95632D6D047BA649F95DAB60E57058C0253@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postcard.dih.oleane.net ([213.56.0.19]:17931 "EHLO
	postcard.dih.oleane.net") by vger.kernel.org with ESMTP
	id S261317AbVAGIsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 03:48:19 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57058C0253@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, 6 Jan 2005 14:31:14 -0500=20
"Mukker, Atul" <Atulm@lsil.com> wrote:

> The target 15/Channel 1 on your first controller ( bus 5:slot 0:func
> 0, fw version:[1.57] bios version:[3.13]) seems to be behaving
> erratically. Can you tell me what kind of device you have on this
> address?
In fact there shouldn't be anything there ...
on the channel 0 I go 2 SCSI disks and on the channel 1 I got a 13 SCSI
disks bay, so the target 15 should be empty ...

> Also, why do you have two versions of the FW on your controllers?
I was wondering too, this box is an old one that was no more used. The
firmwares were like that at the begnining. It was my next task to
upgrade the FW too the same version.

--=20
 #=3D- Stefan Berder                  tel : 6 14 80        -=3D#
 #=3D- Ing=E9nieur syst=E8me et r=E9seau          01 53 95 14 80 -=3D#
 #=3D- TRANSPAC / DO-DAE-ADMG        mail : sbe@oleane.net -=3D#
 #=3D- /(bb|[^b]{2})/      stefan.berder@francetelecom.com -=3D#
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
