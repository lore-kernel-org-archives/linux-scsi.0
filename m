From: Christoph Hellwig <hch@lst.de>
Subject: IP over FC and qlogic workarounds in fusion
Date: Sat, 28 Aug 2004 21:37:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040828193726.GA18499@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:14242 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267657AbUH1Thi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 15:37:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com, andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

Does anyone know whether modern qlogic firmwares fixed the
QLOGIC_NAA_WORKAROUND in mptlan.c?  I'd love to get rid of it so fusion
could use the little bit of common ip over fc infrastructure we have..
