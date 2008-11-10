From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 03/18 ver2] libosd: OSDv1 Headers
Date: Mon, 10 Nov 2008 16:17:33 +0100
Message-ID: <20081110151733.GB16520@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <4916F934.4090205@panasas.com> <20081109174509.GB5350@logfs.org> <4917F50B.3000905@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:59999 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYKJPSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 10:18:21 -0500
Content-Disposition: inline
In-Reply-To: <4917F50B.3000905@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 10 November 2008 10:47:07 +0200, Boaz Harrosh wrote:
>=20
> If the assembly - size and offsets - of foo is exactly the same with =
or
> without the __packed, but the generated code is different then clearl=
y this
> is a compiler bug. I've herd of this myth before, and at least with m=
y
> gcc 4.1.2 there is no such bug. Either the structure gets packed, or =
there is
> no difference. All the places I have __packed in the code are absolut=
ely must
> be so, stated by the protocol.

Ok, if current compilers are fine, I won't complain.

J=C3=B6rn

--=20
There's nothing better for promoting creativity in a medium than
making an audience feel "Hmm =C2=AD I could do better than that!"
-- Douglas Adams in a slashdot interview
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
