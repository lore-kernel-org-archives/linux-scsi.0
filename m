From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels
 2.6.X
Date: Tue, 25 Apr 2006 08:09:17 +0200
Message-ID: <444DBD0D.9010309@s5r6.in-berlin.de>
References: <200604241029.14932.gustavo@compunauta.com> <200604241630.07453.gustavo@compunauta.com> <1145916166.3528.48.camel@mulgrave.il.steeleye.com> <200604241712.26445.gustavo@compunauta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43482 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751010AbWDYGLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 02:11:09 -0400
In-Reply-To: <200604241712.26445.gustavo@compunauta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gustavo_Guillermo_P=E9rez?= <gustavo@compunauta.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Gustavo Guillermo P=E9rez wrote:
> El Lunes, 24 de Abril de 2006 17:02, James Bottomley escribi=F3:
>>So, I could change the long write in progress to a retry.  However, I
>>suspect the reason we got that return is because this device is untag=
ged
>>(doesn't accept multiple commands at once) and perhaps a better fix
>>might be to reduce the queue depth down to one to prevent more than o=
ne
>>command being outstanding at any one time.
>=20
> It would not be better to include some handling on the black list? it=
 means=20
> doing a new BLACK_CONST to handle just this special case?.

=46or now you can and should test a queue depth of one via sbp2:
# modprobe sbp2 serialize_io=3D1

But isn't usb-storage's queue depth already 1?

Dou you use all the different Pioneer drives with the same=20
IDE/USB+FireWire bridge or do you have different bridges?
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D- -=3D-- =3D=3D--=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
