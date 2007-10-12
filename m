From: David Miller <davem@davemloft.net>
Subject: Re: drivers/fc4/fc.c in git-scsi-misc
Date: Thu, 11 Oct 2007 17:38:42 -0700 (PDT)
Message-ID: <20071011.173842.98873625.davem@davemloft.net>
References: <20071011025203.e95690ee.akpm@linux-foundation.org>
	<470E037C.4080204@panasas.com>
	<20071011112058.d95fe040.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54107
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbXJLAij (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 20:38:39 -0400
In-Reply-To: <20071011112058.d95fe040.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: bharrosh@panasas.com, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, matthew@wil.cx

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 11 Oct 2007 11:20:58 -0700

> Well if fc4.c compiles OK on non-sparc64 then perhaps we should enable
> compilation on non-sparc64.  It will increase maintainability and code
> quality and stuff.

No objections to including drivers/fc4/Kconfig directly from
drivers/Kconfig.

It's only included directly from arch/sparc64/Kconfig because
long long ago drivers/Kconfig could not be safely included
there.
