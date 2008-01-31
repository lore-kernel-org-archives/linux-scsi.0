From: Andi Kleen <ak@suse.de>
Subject: Re: Value of __*{init,exit} anotations?
Date: Thu, 31 Jan 2008 06:42:54 +0100
Message-ID: <200801310642.54632.ak@suse.de>
References: <20080130200336.GN29368@does.not.exist> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36326 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYAaFm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 00:42:59 -0500
In-Reply-To: <20080130223219.GT29368@does.not.exist>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>


> Some people consider it worth it for their memory restricted systems
> and would like to drive the annotations even further. [1]

They could get much better bang-for-the-buck (as in memory saved
for amount of work invested) by tackling some the dynamic memory allocation
pigs.

In general it's a trade off between how much work and patch churn versus
benefit, and some of the annotations really don't look too good on this
scale.

> People at linux-arch (Cc'ed) might be better at explaining how often 
> CONFIG_HOTPLUG gets used in real-life systems and how big the savings 
> are there.

CONFIG_HOTPLUG is widely used for suspend on multi core systems. 

-Andi
