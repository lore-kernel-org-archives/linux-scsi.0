From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] [SCSI] Fnic: Not probing all the vNICS via
 fnic_probe on boot
Date: Thu, 20 Nov 2014 07:52:20 -0800
Message-ID: <20141120155220.GA25940@infradead.org>
References: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbaKTPwU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 10:52:20 -0500
Content-Disposition: inline
In-Reply-To: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Shah <hishah@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

Thanks, applied all three patches to drivers-for-3.19.

Any reason you update the version number for every single patch?

