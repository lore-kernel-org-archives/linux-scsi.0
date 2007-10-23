From: David Miller <davem@davemloft.net>
Subject: Re: why disk info gets printk'ed twice?
Date: Mon, 22 Oct 2007 17:08:58 -0700 (PDT)
Message-ID: <20071022.170858.71093449.davem@davemloft.net>
References: <471D1818.3070509@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57898
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbXJWAIh (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2007 20:08:37 -0400
In-Reply-To: <471D1818.3070509@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mjt@tls.msk.ru
Cc: Linux-scsi@vger.kernel.org

From: Michael Tokarev <mjt@tls.msk.ru>
Date: Tue, 23 Oct 2007 01:37:28 +0400

> So it seems to me that scsi_driver.probe() method gets called
> twice for some reason...
> 
> This question has been asked several times, but I don't recall
> any answers to it.

I seem to remember that this happens as a side effect of
how domain-validation works and that it's not easy to get
rid of.
