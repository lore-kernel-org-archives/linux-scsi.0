From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Value of __*{init,exit} anotations?
Date: Thu, 31 Jan 2008 08:44:36 +0100
Message-ID: <20080131074436.GA31966@uranus.ravnborg.org>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:58338 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbYAaHof (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 02:44:35 -0500
Content-Disposition: inline
In-Reply-To: <20080130223219.GT29368@does.not.exist>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

> > 
> > I don't deny we can invest large amounts of work to fix our current
> > issues and build large scriptable checks to ensure we keep it fixed ...
> > I'm just asking if, at the end of the day, it's really worth it.
> 
> Some people consider it worth it for their memory restricted systems
> and would like to drive the annotations even further. [1]
> 
> My experience while fixing section bugs during the last years is that 
> the __dev{init,exit}* are actually the main question since they are both 
> the majority of annotations and the ones that bring benefits only 
> in a case that has become very exotic (CONFIG_HOTPLUG=n).

Some numbers...
I my current tree with an allyesconfig build for x86 64bit I see:
136 Section mismatch warnings in total
99 Section mismatch warnings from drivers/

This is with a few patches of mine applied but none of the recently
posted fixes by Adrian.

I am concentrating on:
drivers/pci/
kernel/
mm/

Will post my patches during the weekend if things goes well.
There are some low hanging fruits in drivers/ but I stay away
from these from now expecting others to fix these.

	Sam
