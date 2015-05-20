From: David Binderman <dcb314@hotmail.com>
Subject: drivers/scsi/be2iscsi/be_main.c:3168: possible bad expression ?
Date: Wed, 20 May 2015 16:19:05 +0000
Message-ID: <DUB128-W492F270195F4472330B00A9CC20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dub004-omc1s21.hotmail.com ([157.55.0.220]:54171 "EHLO
	DUB004-OMC1S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241AbbETQYJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2015 12:24:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jayamohan.kallickal@emulex.com" <jayamohan.kallickal@emulex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello there,

drivers/scsi/be2iscsi/be_main.c:3168:18: warning: logical not is only a=
pplied to the left hand side of comparison [-Wlogical-not-parentheses]
=A0 WARN_ON(!length> 0);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^

Maybe better code

=A0 WARN_ON(length =3D=3D 0);

Regards

David Binderman

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
