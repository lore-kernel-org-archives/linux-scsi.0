From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fusion-MPT much faster as module
Date: Tue, 22 Mar 2005 13:37:10 +0100
Message-ID: <1111495030.7096.71.camel@laptopd505.fenrus.org>
References: <200503221029.j2MATNg12775@unix-os.sc.intel.com>
	 <1111488742.7096.61.camel@laptopd505.fenrus.org>
	 <20050322122801.GI3982@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:25788 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261173AbVCVMh1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 07:37:27 -0500
In-Reply-To: <20050322122801.GI3982@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>, 'Holger Kiehl' <Holger.Kiehl@dwd.de>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Moore, Eric  Dean" <emoore@lsil.com>


> 
> And there are places where it's actually useful:
> 
>   #if defined(CONFIG_FOO) || (defined(MODULE) && defined(CONFIG_FOO_MODULE))
> 
> is a good way to express that driver bar can use functionality of driver 
> foo if it's available.

a good way? I'd disagree with that :)


