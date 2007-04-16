From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 16:28:51 -0700
Message-ID: <20070416232851.GA15840@dmccrory-d810.qlogic.org>
References: <20070416211049.GC13590@andrew-vasquezs-computer.local> <20070416.150846.45744461.davem@davemloft.net> <20070416222517.GD14351@andrew-vasquezs-computer.local> <20070416.152910.107940079.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:54750 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031023AbXDPX24 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 19:28:56 -0400
Content-Disposition: inline
In-Reply-To: <20070416.152910.107940079.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Mon, 16 Apr 2007, David Miller wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Mon, 16 Apr 2007 15:25:17 -0700
> 
> > Fine, I'll agree that wacking-users (and
> > I'll wager the outliers) with a 2x4 was a bit extreme,
> 
> And that, right there, is basically the end of the conversation.
> 
> You don't do this to users, ever.
> Put a big loud kernel log message in there when this situation
> presents itself, use as many capital letters and scary language that
> you wish.  Let them know that if things explode they get to keep the
> pieces.
> 
> But at least try to give them something that works when you know that
> you can.
>
> You don't need to make someone's system unbootable in order to make
> them aware of a potential problem.  It's very anti-social to approach

Sorry, but let's be realistic, this type of warning would have *NEVER*
been addressed if we kept the status quo -- your modifications to read
the wwpn/wwnn would have never been submitted, everybody would have
kept going on blistfully ignorant of the issue.  Changes such as these
are a common Linux upstream idiom...

So, meeting in the middle, with the NVRAM bits restored along with
some ability for the user to *knowingly* recognize the problem, I take
it, is not going to work for you?
