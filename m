From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [PATCH] prepare qla1280 drivers for ISP1020/1040 support
Date: 08 Feb 2004 03:19:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq08yje9e68.fsf@wildopensource.com>
References: <20040206155632.GA4679@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:16611 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S263107AbUBHITP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2004 03:19:15 -0500
In-Reply-To: <20040206155632.GA4679@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> I thought it might be a good idea to not dump a huge patch
Christoph> with all my restructuring at you when I'm done, so here's
Christoph> the bits of the 1040 support I'm already comfortable with
Christoph> and that make sense to merge.

Christoph,

Just a quick note, don't change data types for the sake of changing
them. Ie. the uint8_t->u8 etc. changes are not acceptable.

Cheers,
Jes
