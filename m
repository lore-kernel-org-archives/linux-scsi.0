From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 3/5] scsi: Encapsulate scsi_do_report_luns
Date: Thu, 20 Nov 2014 00:20:44 -0800
Message-ID: <20141120082044.GC29120@infradead.org>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
 <1416237730-1862-4-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaKTIUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 03:20:44 -0500
Content-Disposition: inline
In-Reply-To: <1416237730-1862-4-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

> +int scsi_do_report_luns(struct scsi_device *sdev, int length,
> +			struct scsi_lun *lun_data, char *devname)

I would skip the do and call this scsi_report_luns.  Also shouldn't this
function be marked static?

