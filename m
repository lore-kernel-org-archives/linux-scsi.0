From: Jens Axboe <axboe@kernel.dk>
Subject: Re: loading scsi_debug with data integrity hits BUG_ON
Date: Fri, 21 Feb 2014 15:56:48 -0800
Message-ID: <20140221235648.GG29129@kernel.dk>
References: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
 <1392858619.22195.24.camel@haakon3.risingtidesystems.com>
 <yq1wqgpk325.fsf@sermon.lab.mkp.net>
 <1392924492.29525.22.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42823 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaBUX4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 18:56:52 -0500
Received: by mail-pb0-f50.google.com with SMTP id rq2so4112503pbb.37
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 15:56:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1392924492.29525.22.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, kmo@daterainc.com

On Thu, Feb 20 2014, Nicholas A. Bellinger wrote:
> On Thu, 2014-02-20 at 14:16 -0500, Martin K. Petersen wrote:
> > >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> > 
> > nab> Given that there is no (easy) way to ascertain what the original
> > nab> value of bio_integrity->bip_iter.bi_size was post
> > nab> bio_integrity_advance(), dropping this BUG_ON() probably makes the
> > nab> most sense.
> > 
> > nab> MKP + Jens, care to ACK + pickup..?
> > 
> > Please remove total as suggested by Akinobu.
> > 
> > Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> > 
> 
> Thanks.  Here's an updated patch for Jen's to pickup.

Got it, thanks!

-- 
Jens Axboe

