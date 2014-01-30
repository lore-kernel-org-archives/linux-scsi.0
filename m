From: Hannes Reinecke <hare@suse.de>
Subject: Re: status of drivers/scsi/scsi_tgt_lib.c
Date: Thu, 30 Jan 2014 10:06:11 +0100
Message-ID: <52EA1603.10506@suse.de>
References: <20140124131525.GA30922@infradead.org> <20140125.124832.1568838937885770665.fujita.tomonori@lab.ntt.co.jp> <20140127075038.GA18590@infradead.org> <20140128.004504.1305564732068179852.fujita.tomonori@lab.ntt.co.jp> <52E79B6C.3090809@suse.de> <20140130084444.GA27169@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaA3JGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jan 2014 04:06:13 -0500
In-Reply-To: <20140130084444.GA27169@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On 01/30/2014 09:44 AM, Christoph Hellwig wrote:
> On Tue, Jan 28, 2014 at 12:58:36PM +0100, Hannes Reinecke wrote:
>> I actually know of a customer using this (with a semi-proprietary
>> target mode driver). I'll be asking him what his plans are.
>=20
> They are using the IBM pseries vscsi driver for that?  It they actual=
ly
> adding out of tree kernel code it doesn't really matter at all for th=
is
> discussion..
>=20
No, not the vscsi driver. But the tgt hooks.

But yeah, I know. As said, I'll be in touch with them.
I just wanted mention that _someone_ uses this code

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
