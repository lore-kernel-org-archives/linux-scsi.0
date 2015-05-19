From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RESEND] SCSI: ips: remove pointless #warning
Date: Tue, 19 May 2015 20:42:34 +0200
Message-ID: <17880859.7GjlLRguJk@wuerfel>
References: <3121960.dnOqT9LCth@wuerfel> <2850783.725LtIIUFq@wuerfel> <1432060697.14737.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:59169 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbESSnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2015 14:43:01 -0400
In-Reply-To: <1432060697.14737.1.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org

On Tuesday 19 May 2015 11:38:17 James Bottomley wrote:
> 
> Actually, no, that would cause problems if anyone is actually using this
> driver on non-intel.  What about this?  It captures the intent of the
> original but gets rid of the warning.
> 
> 

Good idea, thanks!

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
