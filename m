From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Minor bug un scsi.h?
Date: Mon, 19 Jan 2004 17:38:24 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119173824.A3176@infradead.org>
References: <Pine.LNX.4.53.0401181220490.18346@calcula.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:18444 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265549AbUASRib (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:38:31 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0401181220490.18346@calcula.uni-erlangen.de>; from gunter@peterpall.de on Sun, Jan 18, 2004 at 05:43:43PM +0100
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Gunter_K=F6nigsmann?= <gunter.koenigsmann@gmx.de>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Sun, Jan 18, 2004 at 05:43:43PM +0100, Gunter K=F6nigsmann wrote:
>=20
> Hello, there!
>=20
> Seems there is a little bug in either cdrdao and cdrecord or in
> linux-2.6.1:
>=20
> When including include/scsi/scsi.h, the variable type u8 is undefined=
, but
> needed there. The definition seems to be in include/asm-arch/types.h.
>=20
> Didn't have problems with Linux-2.4.20.

You are not supposed to include these headers from userspace.  And scsi=
=2Eh
includes linux/types.h which includes asm/types.h anyway..

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
