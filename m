From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: drivers/fc4/fc.c in git-scsi-misc
Date: Fri, 12 Oct 2007 13:04:33 -0500
Message-ID: <1192212273.3342.34.camel@localhost.localdomain>
References: <20071011025203.e95690ee.akpm@linux-foundation.org>
	 <470E037C.4080204@panasas.com>
	 <20071011112058.d95fe040.akpm@linux-foundation.org>
	 <20071011.173842.98873625.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53288 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751958AbXJLTxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Oct 2007 15:53:05 -0400
In-Reply-To: <20071011.173842.98873625.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, bharrosh@panasas.com, linux-scsi@vger.kernel.org, matthew@wil.cx

On Thu, 2007-10-11 at 17:38 -0700, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 11 Oct 2007 11:20:58 -0700
> 
> > Well if fc4.c compiles OK on non-sparc64 then perhaps we should enable
> > compilation on non-sparc64.  It will increase maintainability and code
> > quality and stuff.
> 
> No objections to including drivers/fc4/Kconfig directly from
> drivers/Kconfig.
> 
> It's only included directly from arch/sparc64/Kconfig because
> long long ago drivers/Kconfig could not be safely included
> there.

Would you be able to test out Matthew's patch and ack it?  Not having
fc4 compile is a blocker for the necessary SCSI merge.

James


