From: Christoph Hellwig <hch@infradead.org>
Subject: (unknown)
Date: Wed, 9 Jul 2003 09:15:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709091515.A27879@infradead.org>
References: <20030708222447.GA2232@beaverton.ibm.com> <20030708222541.GB2232@beaverton.ibm.com> <20030708222622.GC2232@beaverton.ibm.com> <20030708222706.GD2232@beaverton.ibm.com> <20030708222759.GE2232@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:39648 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S265771AbTGIIBC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2003 04:01:02 -0400
Received: from phoenix.infradead.org (carisma.slowglass.com [195.224.96.167])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id h698Fb612852
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jul 2003 01:15:38 -0700
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19aA6d-0007HW-00
	for linux-scsi@vger.kernel.org; Wed, 09 Jul 2003 09:15:15 +0100
Content-Disposition: inline
In-Reply-To: <20030708222759.GE2232@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Jul 08, 2003 at 03:27:59PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> +	__set_bit(SDEV_ADD, &sdev->device_flags);

Same atomic vs non atomic issue as in the previous patch.

> +/*
> + * sdev flags
> + */
> +#define SDEV_ADD	1
> +#define SDEV_DEL	2
> +#define SDEV_CANCEL 	3
> +#define SDEV_RECOVERY 	4

Enum again?


> +	unsigned long device_flags;

sdev_state?

