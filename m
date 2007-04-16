From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 16:47:05 -0700
Message-ID: <20070416234705.GA15937@dmccrory-d810.qlogic.org>
References: <20070416222517.GD14351@andrew-vasquezs-computer.local> <20070416.152910.107940079.davem@davemloft.net> <20070416232851.GA15840@dmccrory-d810.qlogic.org> <20070416.164111.32625690.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:58183 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031035AbXDPXsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 19:48:10 -0400
Content-Disposition: inline
In-Reply-To: <20070416.164111.32625690.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Mon, 16 Apr 2007, David Miller wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Mon, 16 Apr 2007 16:28:51 -0700
> 
> > Sorry, but let's be realistic, this type of warning would have
> > *NEVER* been addressed if we kept the status quo
> 
> Wrong.  I watch the logs all the time and would have sent you a fix to
> use the Sparc firmware info as soon as I saw the kernel log message.

Dave, according to your earlier emails, the qla2xxx driver worked
'fine' in driver versions before commit
7aef45ac92f49e76d990b51b7ecd714b9a608be1.  If that were the case, then
you would have seen the warning messages:

	...
	qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
		"invalid -- WWPN) defaults.\n");

> Anyone who has worked with me over the last 15 years will let you know
> emphatically that this is true.
> 
> AND IN THE MEAN TIME I COULD GET WORK DONE AND MY SYSTEM WOULD BOOT!

I understand that, and recognize your contribution, that was never in
question.
