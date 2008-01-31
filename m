From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] kill hotplug init/exit section annotations
Date: Thu, 31 Jan 2008 09:48:01 -0800
Message-ID: <20080131094801.63a048f0@laptopd505.fenrus.org>
References: <20080130200336.GN29368@does.not.exist>
	<1201726817.3292.84.camel@localhost.localdomain>
	<20080130212011.GA26621@uranus.ravnborg.org>
	<1201729295.3292.94.camel@localhost.localdomain>
	<20080130223219.GT29368@does.not.exist>
	<20080131074436.GA31966@uranus.ravnborg.org>
	<1201795051.3131.13.camel@localhost.localdomain>
	<20080131081120.27505dc0@laptopd505.fenrus.org>
	<20080131162141.GC19700@cs181133002.pp.htv.fi>
	<20080131090749.72781689@laptopd505.fenrus.org>
	<20080131171436.GG19700@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55817 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbYAaRs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 12:48:26 -0500
In-Reply-To: <20080131171436.GG19700@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

On Thu, 31 Jan 2008 19:14:36 +0200
Adrian Bunk <bunk@kernel.org> wrote:
> > cpuhotplug is required for suspend/resume.
> 
> Not on UP computers.
> 

great! someone who still has one of those and uses a kernel without it.
Can you look at your system.map and see how many kilobytes you've gained?
Eg how many kilobytes are in these sections exactly?
(but also subtract any cost due to page aligning this stuff ;-)

> cu
> Adrian
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
