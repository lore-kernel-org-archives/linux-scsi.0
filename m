From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH 1/3] libsas: sas_queuecommand doesnt need host_lock
Date: Tue, 19 Jul 2011 16:56:22 +0800
Message-ID: <CC21AAFDD1FD4B9F966CA47480582FF3@usish.com.cn>
References: <20110711184922.859239377@bombadil.infradead.org><20110711185045.179355504@bombadil.infradead.org> <CAA9_cmeHGbdW+c-RE+Lk9+kNy0arxHjU=OPcJZZtnUTLRuH8Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:43280 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GSJew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2011 05:34:52 -0400
In-Reply-To: <CAA9_cmeHGbdW+c-RE+Lk9+kNy0arxHjU=OPcJZZtnUTLRuH8Kw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, 'Christoph Hellwig' <hch@infradead.org>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, "'dave.jiang'" <dave.jiang@intel.com>


> On Mon, Jul 11, 2011 at 11:49 AM, Christoph Hellwig <hch@infradead.org>
wrote:
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> Dave can add his Tested-by, but looks like a nice bump in iops.
[Jack Wang] 
I test it with pm8001, using 512b read with 12 6G sas disks bumps ~460K iops
from 340K iops, but using 512b write performance drops from 340K to 240K.

Dan and Dave , could you share your number?
> 
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

