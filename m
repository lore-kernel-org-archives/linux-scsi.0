From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [PATCH 1/3] libsas: sas_queuecommand doesnt need host_lock
Date: Mon, 18 Jul 2011 16:42:16 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D504CA754E9B@azsmsx504.amr.corp.intel.com>
References: <20110711184922.859239377@bombadil.infradead.org>
	<20110711185045.179355504@bombadil.infradead.org>
 <CAA9_cmeHGbdW+c-RE+Lk9+kNy0arxHjU=OPcJZZtnUTLRuH8Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33755 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1GRXmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2011 19:42:17 -0400
In-Reply-To: <CAA9_cmeHGbdW+c-RE+Lk9+kNy0arxHjU=OPcJZZtnUTLRuH8Kw@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Monday, July 18, 2011 4:40 PM
> To: Christoph Hellwig
> Cc: James.Bottomley@hansenpartnership.com; linux-scsi@vger.kernel.org;
> Jiang, Dave
> Subject: Re: [PATCH 1/3] libsas: sas_queuecommand doesnt need host_lock
> 
> On Mon, Jul 11, 2011 at 11:49 AM, Christoph Hellwig <hch@infradead.org>
> wrote:
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> Dave can add his Tested-by, but looks like a nice bump in iops.
> 
> --
> Dan

Tested-by: Dave Jiang <dave.jiang@intel.com>
