From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 11/12] virtio: Remove code that zeroes
        driver-private command data
Date: Fri, 2 Jun 2017 09:23:06 +0200
Message-ID: <20170602072306.GJ560@lst.de>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com> <20170601232711.29062-12-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51509 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdFBHXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Jun 2017 03:23:07 -0400
Content-Disposition: inline
In-Reply-To: <20170601232711.29062-12-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Michael S . Tsirkin" <mst@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

Nit: the driver name is virtio_scsi, not just virtio.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
