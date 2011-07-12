From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: pm8001 performance degradation?
Date: Tue, 12 Jul 2011 12:18:45 +0800
Message-ID: <9E591616165B4B14A80DE392145C99FC@usish.com.cn>
References: <CAHQAjVFuvh72uJ4x9g-P0XrihfWfUt1YtipTJgd9iXzTS+Vz=w@mail.gmail.com><316E3E573B654596BA694678AE395999@usish.com.cn> <CAHQAjVG_cvvEX99A4ma5waSMs6hjWB_Bgy0oDZ4LgyzwwOpcjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:55948 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1GLESy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 00:18:54 -0400
In-Reply-To: <CAHQAjVG_cvvEX99A4ma5waSMs6hjWB_Bgy0oDZ4LgyzwwOpcjQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'ersatz splatt' <ersatzsplatt@gmail.com>
Cc: lindar_liu@usish.com, linux-scsi@vger.kernel.org

Could you share your fio test scripts? disk detail and HBA firmware ver=
sion
are also wanted if available.

Jack
>=20
> I have one HBA connected directly to 4 SAS drives ... using a single =
1
> to four cable.
>=20
>=20
> On Mon, Jul 11, 2011 at 6:27 PM, Jack Wang <jack_wang@usish.com> wrot=
e:
> >> Hello Jack Wang and Lindar Liu,
> >>
> >>
> >> I am running the pm8001 driver (on applicable hardware including a
> >> several core SMP server).
> >>
> >> When I run on an older kernel -- e.g. 2.6.34.7 -- I get about 73Ki=
ops
> >> via an fio test.
> >>
> >> When I run a current kernel -- e.g. 2.6.39.2 -- on the same system=
 and
> >> same storage I get about 15Kiops running the same fio test.
> >>
> >> Perhaps something has changes in the kernel that is not being acco=
unted
> > for?
> >> Are you two still maintaining this driver?
> >>
> >>
> >> Regards,
> >> David
> > [Jack Wang] =A0Could you give your detailed topology, I will later =
try to
> > investigate the performance issue, but as I remember an Intel devel=
oper
> > reports in mailist some changes in block layer lead to JBOD perform=
ance
> > degradation.
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
