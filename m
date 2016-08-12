From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/4] scsi: bnx2fc: convert per-CPU thread to kworker
Date: Fri, 12 Aug 2016 13:00:27 +0200
Message-ID: <20160812110026.2aluranpmwejxn6h@linutronix.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:56940 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbcHLLAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 07:00:38 -0400
Content-Disposition: inline
In-Reply-To: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com

On 2016-07-05 18:08:46 [+0200], To linux-scsi@vger.kernel.org wrote:
> The driver creates its own per-CPU threads which are updated based on CPU
> hotplug events. It is also possible to use kworkers and remove some of the
> infrastructure get the same job done while saving a few lines of code.

ping

Sebastian
