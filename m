From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sd: Fix rw_max for devices that report an optimal xfer
 size
Date: Wed, 1 Jun 2016 00:52:22 -0700
Message-ID: <20160601075222.GA3438@infradead.org>
References: <1463714194-14258-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbcFAHwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 03:52:22 -0400
Content-Disposition: inline
In-Reply-To: <1463714194-14258-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
