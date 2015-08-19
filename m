From: David Binderman <dcb314@hotmail.com>
Subject: linux-4.2-rc7/drivers/scsi/bfa/bfad_bsg.c:108: bad sanity check on
 array index ?
Date: Wed, 19 Aug 2015 07:34:46 +0000
Message-ID: <DUB128-W4135F31B0C5087EDA6EE5F9C670@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dub004-omc4s13.hotmail.com ([157.55.2.88]:54471 "EHLO
	DUB004-OMC4S13.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbbHSHjt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Aug 2015 03:39:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "anil.gurumurthy@qlogic.com" <anil.gurumurthy@qlogic.com>, "sudarsana.kalluru@qlogic.com" <sudarsana.kalluru@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello there,

[linux-4.2-rc7/drivers/scsi/bfa/bfad_bsg.c:108]: (style) Array index 'i=
' is used before limits check.

Source code is

=A0=A0=A0 for (i =3D 0; iocmd->adapter_hwpath[i] !=3D ':' && i < BFA_ST=
RING_32; i++)

Suggest sanity check array index before use.


Regards

David Binderman

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
