From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 22:51:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824205126.GA10105@suse.de>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:64188 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S268308AbUHXUxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 16:53:15 -0400
Content-Disposition: inline
In-Reply-To: <20040824203914.GA25755@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

 On Tue, Aug 24, Mike Anderson wrote:

> I would guess this cdrom is behind a ACARD. We have had issues in
> the past with negotiation / interaction between the ACARD and the sym=
=2E=20

Oh, that would be possible. I will look through our patches and find th=
e
one that adds an insane delay. Maybe it helps.

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
