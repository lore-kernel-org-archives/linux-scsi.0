From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 2/5] scsi: Fix scsi_report_lun_scan return when
 kmalloc fails
Date: Thu, 20 Nov 2014 00:19:00 -0800
Message-ID: <20141120081900.GB29120@infradead.org>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
 <1416237730-1862-3-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbaKTITA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 03:19:00 -0500
Content-Disposition: inline
In-Reply-To: <1416237730-1862-3-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

What are the chances that the sequential scan will succeed when we
failed to allocate memory for report luns?

