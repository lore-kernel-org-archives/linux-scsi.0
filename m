From: Christoph Hellwig <hch@lst.de>
Subject: what to do with dpt_i2o
Date: Sat, 25 Sep 2004 15:46:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925134622.GA19871@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41702 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269330AbUIYNqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 09:46:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mark_Salyzyn@adaptec.com, markus.lidel@shadowconnect.com
Cc: linux-scsi@vger.kernel.org

Marcus, you'd been doing a lot of testing with the DPT/Adaptec cards for
the new i2o layer, right?  IIRC we now have both support for the Adaptec
managment utils and the optimizes sglist format, so there's probably no
reason anymore to keep dpt_i2o.

If OTOH we want to keep it it would be nice of Mark could finally send
the last round of patches we had agreed on..
