From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] scsi: remove usage of proc_name from scsi_host_alloc
Date: Sun, 13 Nov 2005 16:42:22 +0000
Message-ID: <20051113164222.GA9308@infradead.org>
References: <200511131619.jADGJFwQ032002@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40362 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964928AbVKMQmX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 11:42:23 -0500
Content-Disposition: inline
In-Reply-To: <200511131619.jADGJFwQ032002@einhorn.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 13, 2005 at 05:17:03PM +0100, Stefan Richter wrote:
> scsi_host_alloc: use host template's .name instead of .proc_name in order to
> restrict usage of .proc_name to procfs and sysfs

->name is not mandatory.  You may just implement ->info

