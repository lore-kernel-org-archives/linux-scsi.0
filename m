From: Hannes Reinecke <hare@suse.de>
Subject: Re: Problem with Adaptec 39320A Ultra320 SCSI adapter driver
Date: Tue, 29 Aug 2006 10:33:59 +0200
Message-ID: <44F3FBF7.2050300@suse.de>
References: <3a1eedb70608101101g16527d76ka1d088930a39f365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43495 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750834AbWH2IeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 04:34:00 -0400
In-Reply-To: <3a1eedb70608101101g16527d76ka1d088930a39f365@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jassduec@gmail.com
Cc: linux-scsi@vger.kernel.org

jassduec@gmail.com wrote:
> Hi All,
>=20
> I am running CentOS 4.3 with linux kernel 2.6.9-34.0.2.ELsmp. I am
> using Adaptec 39320A Ultra320 SCSI adapter for connecting to 840 SATA
> RAID Array from gateway. When the system boots, i am getting the
> following errors. Though the kernel is able to identify the LUNs from
> the array, i was wondering what is the cause of the error message. An=
y
> reply in this regard would be highly appreciated.
>=20
> Thanks in advance
>=20
> ########################Error Message########################
>=20
>=20
> scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
>        <Adaptec 39320A Ultra320 SCSI adapter>
>        aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI-X 50-66Mhz,=
 512=20
> SCBs
>=20
> (scsi2:A:4:0): Unexpected busfree in Message-out phase, 1 SCBs
> aborted, PRGMCNT =3D=3D 0x19a
This looks like a external bus-reset.
Ie it might well be that the external box does it's own SCSI bus reset=20
on startup, which will confuse the adapter.
Nothing much we can do about here, but nothing to worry about, either.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
