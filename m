From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 6416] New: AIC79xx crashes with AHA39320 and 6
 LUNs on 1 ID
Date: Thu, 20 Apr 2006 02:36:11 -0700
Message-ID: <20060420023611.21e22082.akpm@osdl.org>
References: <200604200921.k3K9LJ2Y002500@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:64403 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750786AbWDTJhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 05:37:14 -0400
In-Reply-To: <200604200921.k3K9LJ2Y002500@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: oscar@netpromote.hu, linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6416
> 
>             Summary: AIC79xx crashes with AHA39320 and 6 LUNs on 1 ID
>      Kernel Version: 2.6.16.9

Looks like we recurred onto a spinlock, but that driver is so obfuscated
it's rather hard to tell which one.

Can you please retest with CONFIG_DEBUG_SLAB=y, CONFIG_DEBUG_SPINLOCK=y,
CONFIG_DEBUG_SPINLOCK_SLEEP=y, CONFIG_PREEMPT=y and any other CONFIG_DEBUG
options which look useful?

