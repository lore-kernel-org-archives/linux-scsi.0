From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] bnx2fc: fix incorrect DMA memory mapping in
	bnx2fc_map_sg()
Date: Fri, 29 Aug 2014 19:02:25 +0200
Message-ID: <20140829170225.GA15339@lst.de>
References: <1407140413-4561-1-git-send-email-mlombard@redhat.com> <1408556122.10706.20.camel@lbirv-waie-lx2.broadcom.com> <53F7091C.1080400@redhat.com> <alpine.OSX.2.00.1408220805170.360@administrators-macbook-pro.local> <53F7881A.1070808@redhat.com> <1408747587.3876.40.camel@lbirv-waie-lx2.broadcom.com> <alpine.OSX.2.00.1408251511290.1834@administrators-macbook-pro.local> <1409078123.18812.5.camel@lbirv-waie-lx2.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52440 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbaH2RC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2014 13:02:29 -0400
Content-Disposition: inline
In-Reply-To: <1409078123.18812.5.camel@lbirv-waie-lx2.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Maurizio Lombardi <mlombard@redhat.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@lst.de

Chad,

can you send out your last version with a proper changelog, signoff,
and the ack from Eddie included?  Also can you prioritize getting
the shared skb patch tested?

Thanks,
	Christoph
