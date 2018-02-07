From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 0/4] Deprecate DAC960 driver
Date: Tue, 06 Feb 2018 20:08:51 -0500
Message-ID: <yq1lgg51u8s.fsf@oracle.com>
References: <20180124080801.82630-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32790 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932164AbeBGBJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 20:09:06 -0500
In-Reply-To: <20180124080801.82630-1-hare@suse.de> (Hannes Reinecke's message
        of "Wed, 24 Jan 2018 09:07:57 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> as we're trying to get rid of the remaining request_fn drivers here's
> a patchset to move the DAC960 driver to the SCSI stack.  As per
> request from hch I've split up the driver into two new SCSI drivers
> called 'myrb' and 'myrs'.
>
> The 'myrb' driver only supports the earlier (V1) firmware interface,
> which doesn't have a SCSI interface for the logical drives; for those
> I've added a (pretty rudimentary, admittedly) SCSI translation for
> them.
>
> The 'myrs' driver supports the newer (V2) firmware interface, which is
> SCSI based and doesn't need the translation layer.
>
> And the weird proc interface from DAC960 has been converted to sysfs
> attributes.

Thanks for doing this. I merged these into 4.17/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
