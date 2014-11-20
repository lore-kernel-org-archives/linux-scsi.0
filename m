From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 1/5] scsi: Fix scsi_report_lun_scan kmalloc flag
Date: Thu, 20 Nov 2014 00:17:33 -0800
Message-ID: <20141120081733.GA29120@infradead.org>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
 <1416237730-1862-2-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbaKTIRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 03:17:33 -0500
Content-Disposition: inline
In-Reply-To: <1416237730-1862-2-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

This could use a better description like:

	scsi: avoid unessecary GFP_ATOMIC allocation in scsi_report_lun_scan

On Mon, Nov 17, 2014 at 10:22:06AM -0500, Rob Evers wrote:
> ===================================================================

And what's this supposed to be?

