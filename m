From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 19:04:18 +0200
Message-ID: <1123866258.3218.29.camel@laptopd505.fenrus.org>
References: <OF830E5E11.DB8332D4-ON8825705B.005D2AA9-8825705B.005D61FD@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:23974 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750728AbVHLRE0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 13:04:26 -0400
In-Reply-To: <OF830E5E11.DB8332D4-ON8825705B.005D2AA9-8825705B.005D61FD@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, mingz@ele.uri.edu

On Fri, 2005-08-12 at 09:59 -0700, Bryan Henderson wrote:
> >(Not that it's a big problem, sharing irqs on a pci system isn't too big
> >a deal)
> 
> Just how big a deal is it?  How much extra work does Linux have to do for 
> each interrupt?

usually 1 pci mmio read; the rest is negliable.



