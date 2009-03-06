From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 6 Mar 2009 12:59:48 -0800
Message-ID: <da824cf30903061259j4a37ab7cneea308c736da469d@mail.gmail.com>
References: <20090306085529.GP11787@kernel.dk>
	 <20090306181302X.fujita.tomonori@lab.ntt.co.jp>
	 <20090306092114.GS11787@kernel.dk>
	 <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
	 <20090306093520.GV11787@kernel.dk>
	 <20090306143856.GT15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:9464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZCFU7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 15:59:54 -0500
In-Reply-To: <20090306143856.GT15340@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mike.miller@hp.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Fri, Mar 6, 2009 at 6:38 AM,  <scameron@beardog.cca.cpqcorp.net> wro=
te:
=2E..
> The command buffers have to be in the first 4GB of memory, as the com=
mand
> register is only 32 bits, so they are allocated by pci_alloc_consiste=
nt.

Huh?!!
ISTR the mpt2sas driver is indicating it can handle 64-bit DMA masks fo=
r
both streaming and control data. I need to double check to be sure of t=
hat.


> However, the chained SG lists don't have that limitation, so I think =
they
> can be kmalloc'ed, and so not chew up and unreasonable amount of the
> pci_alloc_consistent memory and get a larger number of SGs. =C2=A0 ..=
=2Eright?
> Maybe that's the better way to do it.

I thought the driver was tracking this and using the appropriate constr=
uct
based on which DMA mask is in effect.

hth,
grant

> -- steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
