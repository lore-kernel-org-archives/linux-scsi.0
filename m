From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] be2iscsi: remove potential junk pointer free
Date: Fri, 6 Jun 2014 07:09:24 -0700
Message-ID: <20140606140924.GB4444@infradead.org>
References: <5391B294.5020104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaFFOJZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 10:09:25 -0400
Content-Disposition: inline
In-Reply-To: <5391B294.5020104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, jayamohank@gmail.com, sony.john-n@emulex.com

On Fri, Jun 06, 2014 at 02:22:44PM +0200, Tomas Henzl wrote:
> commit 0e7c60c [SCSI] be2iscsi: fix memory leak in error path
> fixed an potential junk pointer free if  mgmt_get_if_info() returned an error
> 
> fix it on one more place
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
