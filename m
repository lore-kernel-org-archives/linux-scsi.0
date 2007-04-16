From: David Miller <davem@davemloft.net>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 15:08:46 -0700 (PDT)
Message-ID: <20070416.150846.45744461.davem@davemloft.net>
References: <20070416.123743.07452378.davem@davemloft.net>
	<20070416200857.GH10822@andrew-vasquezs-computer.local>
	<20070416211049.GC13590@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32839
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031003AbXDPWIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2007 18:08:45 -0400
In-Reply-To: <20070416211049.GC13590@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 16 Apr 2007 14:10:49 -0700

> Ok, how about the following patch based on the one you posted which
> adds the codes to retrieve the WWPN/WWNN from firmware on SPARC, and
> also adds the module-parameter override I mentioned above.
> 
> Perhaps the module-parameter should be set to non-zero in the case of
> SPARC, to take care of your system configurations?

I think it should default to non-zero always, in fact the option
is completely pointless.

The guy who hits this had a system which worked previously, and you're
explicitly breaking it.  That's wrong.

How can you not see that this quality of implementation decision
you're making stinks?
