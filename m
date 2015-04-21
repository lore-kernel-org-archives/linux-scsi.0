From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: use raw_smp_processor_id()
Date: Tue, 21 Apr 2015 12:15:19 +0200
Message-ID: <55362337.7090209@suse.de>
References: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com> <20150415164437.GA17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbbDUKPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:15:22 -0400
In-Reply-To: <20150415164437.GA17287@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@amacapital.net>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, Linux SCSI List <linux-scsi@vger.kernel.org>

On 04/15/2015 06:44 PM, Christoph Hellwig wrote:
> We only want to steer the I/O completion towards a queue, but don't
> actually access any per-CPU data, so the raw_ version is fine to use
> and avoids the warnings when using smp_processor_id().
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Andy Lutomirski <luto@kernel.org>
> Tested-by: Andy Lutomirski <luto@kernel.org>
> Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
