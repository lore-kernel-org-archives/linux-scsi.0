From: Chris Stromsoe <cbs@cts.ucla.edu>
Subject: Re: Symbios Logic 53C876 detected as 53C875, then doesn't work
Date: Sat, 12 Aug 2006 13:43:32 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608121341470.5956@potato.cts.ucla.edu>
References: <Pine.LNX.4.64.0608120108330.21468@potato.cts.ucla.edu>
 <20060812132213.GA789@parisc-linux.org> <Pine.LNX.4.64.0608121320530.5419@potato.cts.ucla.edu>
 <20060812203251.GB789@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-4.smtp.ucla.edu ([169.232.46.137]:42122 "EHLO
	smtp-4.smtp.ucla.edu") by vger.kernel.org with ESMTP
	id S1422683AbWHLUnd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 16:43:33 -0400
In-Reply-To: <20060812203251.GB789@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sat, 12 Aug 2006, Matthew Wilcox wrote:

> If there's dodgy connectors, then the card probably detected a PCI 
> parity error and went fatal.  I think it'd be useful to leverage the PCI 
> error recovery framework to at least display a useful error message to 
> the user on systems with little or no support for error *recovery*.

It's definitely a PCI problem.  Moving all of the cards to a different 
system detects them properly.  Thanks for the pointer.

-Chris
