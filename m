From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: Fusion-MPT much faster as module
Date: Tue, 22 Mar 2005 11:52:22 +0100
Message-ID: <1111488742.7096.61.camel@laptopd505.fenrus.org>
References: <200503221029.j2MATNg12775@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:28080 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262621AbVCVKwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 05:52:37 -0500
In-Reply-To: <200503221029.j2MATNg12775@unix-os.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: 'Holger Kiehl' <Holger.Kiehl@dwd.de>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Moore, Eric  Dean" <emoore@lsil.com>

On Tue, 2005-03-22 at 02:29 -0800, Chen, Kenneth W wrote:

> Before:
> /dev/sdc:
>  Timing buffered disk reads:   92 MB in  3.03 seconds =  30.32 MB/sec
> 
> After:
> /dev/sdc:
>  Timing buffered disk reads:  174 MB in  3.02 seconds =  57.61 MB/sec


nice!

More proof that #ifdef MODULE is considered harmful... how much of it is
actually left in the kernel? Maybe we could kill it entirely from
drivers/*  (of course it has a limited place in include/*)



