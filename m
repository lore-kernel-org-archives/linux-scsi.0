From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi: add support for a blk-mq based I/O path.
Date: Tue, 16 Sep 2014 18:19:14 +0200
Message-ID: <20140916161914.GA2756@lst.de>
References: <54184C09.70800@linuxbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36953 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbaIPQTR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2014 12:19:17 -0400
Content-Disposition: inline
In-Reply-To: <54184C09.70800@linuxbox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Gryniewicz <dang@linuxbox.com>
Cc: linux-scsi@vger.kernel.org

Hi Daniel,

this should also be fixed with my patch "scsi: clean up S/G table freeing",
can you test if that fixes the issue for you as well?

