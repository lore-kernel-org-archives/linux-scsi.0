From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 00/37] Fixes, cleanups and modernization for NCR5380
 drivers
Date: Thu, 20 Nov 2014 07:56:59 -0800
Message-ID: <20141120155659.GA2450@infradead.org>
References: <20141112051146.525489687@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbaKTP5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 10:57:06 -0500
Content-Disposition: inline
In-Reply-To: <20141112051146.525489687@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Thanks, I've applied all patches to the drivers-for-3.19 branch.

I had a few rejects due to Hannes logging changes.  I think I've fixed
them properly, but please verify it.
