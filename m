From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi: convert unrecovered read error to -EILSEQ
Date: Wed, 19 Apr 2017 22:37:11 -0700
Message-ID: <20170420053711.GA10381@infradead.org>
References: <1491221029-1609-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39305 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941484AbdDTFhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 01:37:12 -0400
Content-Disposition: inline
In-Reply-To: <1491221029-1609-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Looks like I won't get the major error status changes into 4.12,
so let's go with these patches for now:

Reviewed-by: Christoph Hellwig <hch@lst.de>
