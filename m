From: David Miller <davem@davemloft.net>
Subject: Re: Remove FC4 and all associated drivers
Date: Mon, 15 Oct 2007 22:11:15 -0700 (PDT)
Message-ID: <20071015.221115.36921776.davem@davemloft.net>
References: <20071016050507.GB15744@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34944
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbXJPFLK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 01:11:10 -0400
In-Reply-To: <20071016050507.GB15744@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Mon, 15 Oct 2007 23:05:07 -0600

>     Remove FC4 and all associated drivers
>     
>     This code has been slowly rotting for about eight years.  It's currently
>     impeding a few SCSI cleanups, and nobody seems to have hardware to test
>     it any more.  I talked to Dave Miller about it, and he agrees we can
>     delete it.  If anyone wants a software FC stack in future, they can
>     retrieve this driver from git.
>     
>     Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Acked-by: David S. Miller <davem@davemloft.net>
