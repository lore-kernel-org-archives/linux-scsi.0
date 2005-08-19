From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/2] fusion SAS support
Date: Fri, 19 Aug 2005 18:26:34 +0200
Message-ID: <20050819162634.GA15401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:31964 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964994AbVHSQ0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 12:26:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

This patch implements minimal SAS support for fusion.  It needs the
previous set of fusion updates and the minimal SAS transport class to
work.  I'll probably revisit the transport class later to introduce a
rport object, but I'll need some real enclosures with extenders and
SMP ports to experiment with first.  So my suggestion is to put the
current state of the art into scsi-misc so it gets exposure in -mm
and people can start reviwing the design and send patches.  (Lots
of thanks to James Smart btw, I had hoped to get more of this
constructive critizism).

