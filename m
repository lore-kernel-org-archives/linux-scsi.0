From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: loading scsi_debug with data integrity hits BUG_ON
Date: Thu, 20 Feb 2014 14:16:18 -0500
Message-ID: <yq1wqgpk325.fsf@sermon.lab.mkp.net>
References: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
	<1392858619.22195.24.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaBTTQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 14:16:34 -0500
In-Reply-To: <1392858619.22195.24.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Wed, 19 Feb 2014 17:10:19 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, kmo@daterainc.com

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> Given that there is no (easy) way to ascertain what the original
nab> value of bio_integrity->bip_iter.bi_size was post
nab> bio_integrity_advance(), dropping this BUG_ON() probably makes the
nab> most sense.

nab> MKP + Jens, care to ACK + pickup..?

Please remove total as suggested by Akinobu.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
