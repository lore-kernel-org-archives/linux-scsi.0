From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [sg3_utils] report target group
Date: Sat, 01 Jan 2005 13:57:44 +0100
Message-ID: <1104584264.5752.4.camel@zezette>
References: <1104233396.41d143b44e073@imp5-q.free.fr>
	 <41D21DDD.5010109@torque.net> <1104307397.41d264c5c5d3c@imp5-q.free.fr>
	 <41D2AF42.5050007@torque.net> <1104327781.41d2b4654846d@imp5-q.free.fr>
	 <41D38DBF.6010303@torque.net> <1104415233.41d40a018c287@imp5-q.free.fr>
	 <1104415927.41d40cb782493@imp5-q.free.fr>  <41D623BF.8060304@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.wanadoo.fr ([193.252.22.29]:61557 "EHLO smtp2.wanadoo.fr")
	by vger.kernel.org with ESMTP id S261648AbVAGVvf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 16:51:35 -0500
In-Reply-To: <41D623BF.8060304@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le samedi 01 janvier 2005 =C3=A0 14:14 +1000, Douglas Gilbert a =C3=A9c=
rit :
> christophe.varoqui@free.fr wrote:
> >>All in all, I don't really see how one can use the result of RTPG.
> >>
> >=20
> > Ok, sorry to bug around.
> > the response is at chapter 7.6.8 of SPC-3 :
> > VPD page 88h contains the mapping between relative port ids and por=
t ids
>=20
> sg_inq -s /dev/sda
>=20
> decodes the SCSI Ports VPD (0x88) page. Evidentally it will
> be present in SAS dual ported disks.
>=20
> So is sg_rtpg of any use?
>=20
I have yet to see the output of these commands on a device that support=
s
them, but I think the multipath can use that quite well.

I have added a call for contribution for that on the webpage.

thanks for the help,
--=20
christophe varoqui <christophe.varoqui@free.fr>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
