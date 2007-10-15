From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/3] pluto/fc - Enable compilation for all ARCHs
Date: Mon, 15 Oct 2007 12:09:49 -0600
Message-ID: <20071015180949.GC25488@parisc-linux.org>
References: <4713A175.9020408@panasas.com> <4713A2DB.2000302@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46493 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbXJOSJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 14:09:50 -0400
Content-Disposition: inline
In-Reply-To: <4713A2DB.2000302@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

On Mon, Oct 15, 2007 at 07:26:51PM +0200, Boaz Harrosh wrote:
> @@ -22,6 +22,8 @@ source "drivers/misc/Kconfig"
>  
>  source "drivers/ide/Kconfig"
>  
> +source "drivers/fc4/Kconfig"
> +
>  source "drivers/scsi/Kconfig"
>  
>  source "drivers/ata/Kconfig"

I think I see two problems ... one is that fc4 plainly depends on SCSI,
yet it's not mentioned in the fc4 Kconfig file.  The other is that,
given this dependency, fc4 should come after scsi.  And maybe even be
included from drivers/scsi/Kconfig rather than drivers/Kconfig.  I don't
have a strong feeling on that last point.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
