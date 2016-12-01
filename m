From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs: configfs: don't return anything from drop_link
Date: Thu, 1 Dec 2016 10:53:12 +0100
Message-ID: <20161201095312.GA26366@lst.de>
References: <CGME20161128122258eucas1p2c3543f6795fe54c07175a5f5fbae0765@eucas1p2.samsung.com> <1480335762-26408-1-git-send-email-andrzej.p@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52387 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbcLAKD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 05:03:59 -0500
Content-Disposition: inline
In-Reply-To: <1480335762-26408-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Joel Becker <jlbec@evilplan.org>, linux-doc@vger.kernel.org, b.zolnierkie@samsung.com

Thanks a lot Andrzej!

I've applied the patch, but I undid the reformatting of the nvmet
code to keep the patch as simple as possible.
