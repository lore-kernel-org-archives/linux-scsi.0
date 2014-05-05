From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.0 14/16] arcmsr: fix sparse checking error
Date: Mon, 5 May 2014 15:10:36 +0300
Message-ID: <20140505121036.GO4963@mwanda>
References: <1398857906.6930.59.camel@localhost>
 <20140502091315.GG4963@mwanda>
 <CAKiknE-cJZpkpjMEPiX_cP4iC3e_b5huk2WJBvK2FpkKHecJoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49692 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbaEEMKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 08:10:53 -0400
Content-Disposition: inline
In-Reply-To: <CAKiknE-cJZpkpjMEPiX_cP4iC3e_b5huk2WJBvK2FpkKHecJoQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: James Bottomley <jbottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, May 05, 2014 at 12:10:39PM +0800, =E9=BB=83=E6=B8=85=E9=9A=86 w=
rote:
> Hi Dan,
>=20
> In this patch, there are several replace of call readl() or writel()
> by direct access to memory.
> Because in main memory, we allocated a block of memory for
> post_qbuffer and done_qbuffer.
> These memory are access by both of CPU and IOP, they are not hardware=
 registers.
> This change will not introduce a bug. I have verified it.
>=20

Oh yeah.  I see that now.  I got mixed up.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
