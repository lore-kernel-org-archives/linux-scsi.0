From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] Rework handling of scsi_device.vpd_pg8[03]
Date: Mon, 28 Aug 2017 10:07:53 +0200
Message-ID: <20170828080753.GB2851@lst.de>
References: <20170825203601.23612-1-bart.vanassche@wdc.com> <20170825203601.23612-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37377 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751879AbdH1IHz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 04:07:55 -0400
Content-Disposition: inline
In-Reply-To: <20170825203601.23612-3-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane Seymour <shane.seymour@hpe.com>

This looks generally good.  But I wonder if there is a way to
factor the assining/clearing sequence into little helpers instead
of duplicating it?
