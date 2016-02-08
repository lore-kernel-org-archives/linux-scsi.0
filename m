From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Mon, 8 Feb 2016 12:01:16 +0200
Message-ID: <56B8676C.20600@dev.mellanox.co.il>
References: <1454783624.2809.6.camel@HansenPartnership.com>
 <20160207092241.GA15331@lst.de>
 <1454861040.2329.4.camel@HansenPartnership.com> <56B7C527.6050300@kernel.dk>
 <1454886441.2329.27.camel@HansenPartnership.com> <56B8448A.3000106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34683 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbcBHKBW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2016 05:01:22 -0500
Received: by mail-wm0-f48.google.com with SMTP id 128so147610114wmz.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Feb 2016 02:01:21 -0800 (PST)
In-Reply-To: <56B8448A.3000106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>


> Do we have defined sysfs attributes for NVMe devices nowadays?

/sys/block/nvme0n1/uuid

> If so I'd be willing to create/send some sysfs rules for them.

That'd be great!
