From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] qla2xxx: Move Command residual check from qla2xxx to
 tcm_qla2xxx
Date: Sun, 18 Dec 2016 01:51:04 -0800
Message-ID: <20161218095104.GD23338@infradead.org>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
 <1482051769-22941-6-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757418AbcLRJvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2016 04:51:05 -0500
Content-Disposition: inline
In-Reply-To: <1482051769-22941-6-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

NAK again, duplicating a field in a common structure in a
driver-specific one is an absolute anti-pattern.
