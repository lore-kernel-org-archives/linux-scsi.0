From: Christoph Hellwig <hch@lst.de>
Subject: mac_scsi / mac_NC5380
Date: Sat, 22 Nov 2003 12:41:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031122114135.GA8147@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:2743 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262198AbTKVLlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 06:41:37 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org

In mailine mac_scsi uses the generic NC5380 core, not the slightly
modified copy mac_NC5380.c that someone created for it long time
ago.  Is it actually working that way in some tree?  I'd love to
get rid of mac_NC5380 if possible so we're down three from four
slightly differrent "generic" NC5380 drivers.

If someone looked into porting the other drivers to main generic
one that would of course be cool, especially as it got some major
work from Alan lately and does proper looking, error handling, etc..
