From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi_debug: fix sleep in invalid context
Date: Thu, 9 Jun 2016 02:14:09 -0700
Message-ID: <20160609091409.GB28401@infradead.org>
References: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
 <20160607115525.GA30861@infradead.org>
 <5757C1F3.2070607@interlog.com>
 <5758FC37.2000801@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbcFIJOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2016 05:14:11 -0400
Content-Disposition: inline
In-Reply-To: <5758FC37.2000801@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com

Oh well,

not a fan og the casting, but as this is an important fix let's get
it in for now:

Acked-by: Christoph Hellwig <hch@lst.de>
