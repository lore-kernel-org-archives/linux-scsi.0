From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] be2iscsi: add an missing goto in error path
Date: Fri, 6 Jun 2014 07:08:54 -0700
Message-ID: <20140606140854.GA4444@infradead.org>
References: <5391AEC6.1040207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaFFOIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 10:08:54 -0400
Content-Disposition: inline
In-Reply-To: <5391AEC6.1040207@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, jayamohank@gmail.com, sony.john-n@emulex.com

On Fri, Jun 06, 2014 at 02:06:30PM +0200, Tomas Henzl wrote:
> a jump to 'free_memory' is apparently missing
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
