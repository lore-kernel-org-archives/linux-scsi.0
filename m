From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] link scsi_debug later
Date: Fri, 17 Mar 2006 21:29:24 -0800
Message-ID: <20060317212924.11a86800.akpm@osdl.org>
References: <20060317124407.5f19cc09.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:37074 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751474AbWCRFcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 00:32:17 -0500
In-Reply-To: <20060317124407.5f19cc09.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

"Randy.Dunlap" <rdunlap@xenotime.net> wrote:
>
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Link scsi-debug driver after SATA so that scsi-debug does not
> interfere with real SCSI device ordering.
> Yes, I was bitten by this.
> 

What does "bitten" mean?

Is this a regression?

If so, relative to which release?

Potentially this sort of thing can have serious effects.  Like, non-booting
machines.  Is that the case here?

Is this 2.6.16 material?

Stuff like that, thanks.
