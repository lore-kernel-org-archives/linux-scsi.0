From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Mon, 25 Oct 2010 08:02:22 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3010111F771@cosmail02.lsi.com>
References: <20101023095816.GA19791@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F73E@cosmail02.lsi.com>
 <20101025131937.GA6605@apartia.fr>
 <20101025154705.73d49860@harpe.intellique.com>
 <20101025135647.GA14302@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:59354 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab0JYOCp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 10:02:45 -0400
In-Reply-To: <20101025135647.GA14302@apartia.fr>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

You also can use ctrl^H during the controller post to configure the JBO=
D. =20

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Louis-David Mitterrand
Sent: Monday, October 25, 2010 9:57 AM
To: linux-scsi@vger.kernel.org
Subject: Re: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?

On Mon, Oct 25, 2010 at 03:47:05PM +0200, Emmanuel Florac wrote:
> Le Mon, 25 Oct 2010 15:19:37 +0200
> Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org> =E9criva=
it:
>=20
> > Could you tell me what LSI app do I need? Does it run under Linux?
> >=20
>=20
> It's called MegaCli. Find it here :
>=20
> http://www.lsi.com/storage_home/products_home/internal_raid/megaraid_=
sas/megaraid_sas_8888elp/index.html#Miscellaneous
>=20

OK, I installed it and tried:

	MegaCli64 -AdpSetProp -EnableJBOD -1 -aALL

but this seems to do nothing (maybe after reboot?), and

	MegaCli64 -PDMakeJBOD -PhysDrv 0:0 -aAll

gives this error (tried most permutations):

	Invalid input at or near token 0=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
