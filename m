From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag support
 for internal command indexing
Date: Tue, 21 Apr 2015 03:42:10 -0700
Message-ID: <20150421104210.GC8920@infradead.org>
References: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbDUKmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 06:42:11 -0400
Content-Disposition: inline
In-Reply-To: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

This patch needs to be split up:  the return_cmd calling convenion
changes should be a pach on it's own, the various new debug printks
should be a patch on their own, or better jsut be dropped.

Also please drop the BLK_TAG_REFCOUNT/DEBUG code that shouldn't be ina
production driver.
