From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Block/SCSI data integrity update v2
Date: Sat, 26 Jul 2014 09:23:07 -0700
Message-ID: <20140726162307.GA19441@infradead.org>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaGZQXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 12:23:08 -0400
Content-Disposition: inline
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

I haven't done an in-depth review of the whole series, but it looks
generally good to me.  How should we pull it in?  Normally block
stuff should go through Jens, but the sd changes won't apply without
the various patches in the scsi tree.

