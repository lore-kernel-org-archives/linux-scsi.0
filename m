From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH 1/3] libsas: sas_queuecommand doesnt need host_lock
Date: Fri, 22 Jul 2011 22:05:15 -0400
Message-ID: <20110723020515.GA13022@infradead.org>
References: <20110711184922.859239377@bombadil.infradead.org>
 <20110711185045.179355504@bombadil.infradead.org>
 <CAA9_cmeHGbdW+c-RE+Lk9+kNy0arxHjU=OPcJZZtnUTLRuH8Kw@mail.gmail.com>
 <CC21AAFDD1FD4B9F966CA47480582FF3@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54957
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab1GWCFV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 22:05:21 -0400
Content-Disposition: inline
In-Reply-To: <CC21AAFDD1FD4B9F966CA47480582FF3@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: 'Dan Williams' <dan.j.williams@intel.com>, 'Christoph Hellwig' <hch@infradead.org>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, "'dave.jiang'" <dave.jiang@intel.com>

On Tue, Jul 19, 2011 at 04:56:22PM +0800, Jack Wang wrote:
> [Jack Wang] 
> I test it with pm8001, using 512b read with 12 6G sas disks bumps ~460K iops
> from 340K iops, but using 512b write performance drops from 340K to 240K.

Very strange.  Is this repeatable, and did you test with just patch 1,
or the whole series?

