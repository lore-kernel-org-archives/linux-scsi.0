From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/22] qla2xxx: Fix wrong IOCB type assumption.
Date: Wed, 14 Dec 2016 13:09:53 -0800
Message-ID: <20161214210953.GE1011@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-2-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53384 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753628AbcLNVKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 16:10:15 -0500
Content-Disposition: inline
In-Reply-To: <1481056251-2310-2-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Tue, Dec 06, 2016 at 12:30:30PM -0800, Himanshu Madhani wrote:
> +	uint32_t unpacked_lun = 0;

Please remove the unpacked_lun variable as well, and just directly
pass 0 to qlt_issue_task_mgmt.
