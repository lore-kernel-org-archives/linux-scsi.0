From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] sd: Make discard granularity match logical block
 size when LBPRZ=1
Date: Thu, 19 Nov 2015 00:24:56 -0800
Message-ID: <20151119082456.GB11419@infradead.org>
References: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbbKSIY5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2015 03:24:57 -0500
Content-Disposition: inline
In-Reply-To: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
