From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Sat, 14 Dec 2002 22:55:17 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021214223934.P3547-100000@localhost.my.domain>
References: <20021211153935.A23704@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021211153935.A23704@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org


On Wed, 11 Dec 2002, Christoph Hellwig wrote:

[...]

> linux driver interface change between stable series, face it.  And a =
driver
> with tons of ifdefs is utter crap.  Interestingly only vendor driver =
use
> that shitty scheme.

You just miss that new hardware must be supported for both stable and
current kernels and that differences in driver interface use to be larg=
e
between adjacent stable and current in Linux. On the other hand driver
interfaces in current kernel seem to be changing as new features come t=
o
mind to developpers. Add to that mess that not all Linux based O/S are
using kernel at same level.

Btw, people who want to learn about how to design and maintain a smart
driver interface that can evolve gracefully without breaking driver
zillions of times should ask Justin how it does this so well with
=46reeBSD/CAM, in my opinion.

  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
