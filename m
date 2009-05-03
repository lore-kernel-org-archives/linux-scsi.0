From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 03 May 2009 17:08:30 +0200
Message-ID: <49FDB36E.7010402@tremplin-utc.net>
References: <49FDA2CA.4040601@tremplin-utc.net> <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailservice.tudelft.nl ([130.161.131.5]:22220 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbZECPIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 11:08:36 -0400
In-Reply-To: <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

James Bottomley schreef:
> On Sun, 2009-05-03 at 15:57 +0200, =C3=89ric Piel wrote:
:
>=20
> Actually, I'd really rather not alter the default value of this setti=
ng.
> Multi-lun is rapidly becoming obsolete: any modern devices conforming=
 to
> SCSI-3 use REPORT LUNS instead of doing LUN scanning, which gets us o=
ut
> of the issue.  Conversely, the ancient devices which rely on correctl=
y
> setting this are more likely to get upset about any change in the
> balance.
Yes, I understand. Would like me to resend the patch without the change
on the default value. IMHO, it provides a better wording.

>=20
> In your case, just add the changer's inquiry strings with a
> BLIST_FORCELUN.
Where, into the usb-storage driver? I guess there is no usb device whic=
h
can get confused by this, so it should work fine as well :-)

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
