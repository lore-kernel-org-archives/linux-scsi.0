From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: [gregoire.favre@gmail.com: What breaks aic7xxx in post 2.6.12-rc2 ?]
Date: Mon, 16 May 2005 17:54:09 +0200
Message-ID: <20050516155409.GE9558@gmail.com>
References: <20050516152607.GA27989@infradead.org> <1116258401.5040.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.204]:65299 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261687AbVEPPyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 11:54:14 -0400
Received: by wproxy.gmail.com with SMTP id 68so2291680wra
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 08:54:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1116258401.5040.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, May 16, 2005 at 10:46:41AM -0500, James Bottomley wrote:

> As I read it, nothing is going wrong ... the trace indicates that the
> device is eventually configured async by DV, so the system comes up w=
ith
> it's full complement of devices.  Which device is this by the way, th=
e
> inquiry information is missing from the top.
>=20
> The bug is that the DV code should shut the driver up while it probes=
 to
> avoid frightening users (particularly as the aic7xxx driver prints lo=
ts
> of scary messages while its in error handling).

What's DV ?

With 2.6.12-rc4 the system finally boots, but it took about 30
minutes... so it must be some changes introduced in 2.6.12-rc3 that my
computer don't like.

Here's my /proc/scsi/scsi :

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DDRS-39130D      Rev: DC1B
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 15 Lun: 00
  Vendor: SEAGATE  Model: ST336706LW       Rev: 0108
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: TOSHIBA  Model: DVD-ROM SD-M1201 Rev: 1R08
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: PLEXTOR  Model: CD-R   PX-R820T  Rev: 1.08
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 03 Lun: 00
  Vendor: PLEXTOR  Model: CD-R   PX-R820T  Rev: 1.08
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6B200M0   Rev: BANC
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: SMSC     Model: 223 U HS-CF      Rev: 3.60
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi7 Channel: 00 Id: 00 Lun: 01
  Vendor: SMSC     Model: 223 U HS-MS      Rev: 3.60
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi7 Channel: 00 Id: 00 Lun: 02
  Vendor: SMSC     Model: 223 U HS-SM      Rev: 3.60
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi7 Channel: 00 Id: 00 Lun: 03
  Vendor: SMSC     Model: 223 U HS-SD/MMC  Rev: 3.60
  Type:   Direct-Access                    ANSI SCSI revision: 02

Which info should I sent in order to find what's the problem is ?

Thank you and please keep CC to me as I am not in this ml.
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
