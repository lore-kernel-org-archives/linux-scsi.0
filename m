From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Re:[ANNOUNCE] QLogic FC Driver for Linux kernel 2.5 available.
Date: Tue, 13 May 2003 14:04:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513135931.A83125@mailhost.quaver.net>
References: <3EBDB953.1040908@wanadoo.es>  <20030512190013.GA23981@praka.local.home>
 <1052768456.2093.64.camel@mulgrave>
Reply-To: mjacob@quaver.net
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com ([192.67.166.79]:523 "EHLO beppo.feral.com")
	by vger.kernel.org with ESMTP id S261219AbTEMUyj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 16:54:39 -0400
In-Reply-To: <1052768456.2093.64.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Vasquez <praka@san.rr.com>, linux-scsi <linux-scsi@vger.kernel.org>


You typically have to sign an NDA for such information :-(.

It's really not all that hard to support the older chips though. A more
crucial piece of information is the chip errata- issues like the first
cut of the 1080 chip not working with Seagate drives but with Quantum
and IBM drives- those pieces of info are very hard to get ahold of.

Personally, *I* care about the older chipsets. I *do* support them in my
somewhat problematic linux driver. I also have active target mode
support in a number of contexts for them because I actually *do* have
people who still need this support.

This is also a non-PCI issue as there are still boatloads of the ISP1000
SBus cards out there as well.



On Mon, 12 May 2003, James Bottomley wrote:

> On Mon, 2003-05-12 at 14:00, Andrew Vasquez wrote:
> > Unfortunately, no.  QLogic has no plans to update qla1280 -- all
> > parallel SCSI HBAs have been EOLed.
>
> Could Qlogic at least publish the documentation for these chips
> electronically so we have a vague chance of supporting them?
>
> At the moment most of the ISP1020 and ISP1040 bug reports elicit
> sympathy but not much else.
>
> James
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
