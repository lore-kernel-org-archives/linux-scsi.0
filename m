From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] de-uglify scsi.c
Date: Sun, 27 Apr 2003 07:42:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427074203.A25568@lst.de>
References: <20030426190303.A20780@lst.de> <20030426183407.A18575@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:17418 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263385AbTD0F3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 01:29:55 -0400
Content-Disposition: inline
In-Reply-To: <20030426183407.A18575@beaverton.ibm.com>; from patmans@us.ibm.com on Sat, Apr 26, 2003 at 06:34:07PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Apr 26, 2003 at 06:34:07PM -0700, Patrick Mansfield wrote:
> Christoph -
> 
> Thanks for cleaning up these and the prior ones.
> 
> I still needed interrupt.h to compile (with CONFIG_NOHIGHMEM=y) for
> softirq code.

Yes;, that's right.  (stupid implicit headers..)

