From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 11:38:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026103828.GC12026@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF031@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:34317 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262207AbUJZKig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 06:38:36 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57053AF031@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 25, 2004 at 07:32:35PM -0400, Moore, Eric Dean wrote:
> All,
>=20
> We are pleased to announce the MPT Fusion release candidate for lk 2.=
6

Some things that come to mind immediately:

>=20
>=20
> Highlights of this release:
> =B7	SAS Support - 1064, 1066, 1068

there's still tons of ioc->chip_type checks for SPI vs FC vs SAS -=20
please always use the new bus_type member


> =B7	csmi ioctl support

rejected, this ioctl interface is completely horrible, even worse than
the fc hbaapi.  Please help to provide a proper sas transport class sim=
ilar
to the fc one.

> =B7	fc_transport support

please don't put this under all kinds of ifdefs, also it's not working =
with
current mainline anymore anyway.

Any reason there's no SPI transport attribute support, it's rather asym=
etric
this way..

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
