From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid_sas : Fix bug in handling return value of
 pci_enable_msix_range()
Date: Thu, 6 Nov 2014 08:51:39 -0800
Message-ID: <20141106165139.GA17176@infradead.org>
References: <1415018660-30775-1-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaKFQvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 11:51:48 -0500
Content-Disposition: inline
In-Reply-To: <1415018660-30775-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Alexander Gordeev <agordeev@redhat.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Thanks,

applied to the drivers-for-3.18 branch.

