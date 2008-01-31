From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] kill hotplug init/exit section annotations
Date: Thu, 31 Jan 2008 08:11:20 -0800
Message-ID: <20080131081120.27505dc0@laptopd505.fenrus.org>
References: <20080130200336.GN29368@does.not.exist>
	<1201726817.3292.84.camel@localhost.localdomain>
	<20080130212011.GA26621@uranus.ravnborg.org>
	<1201729295.3292.94.camel@localhost.localdomain>
	<20080130223219.GT29368@does.not.exist>
	<20080131074436.GA31966@uranus.ravnborg.org>
	<1201795051.3131.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54061 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbYAaQLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 11:11:44 -0500
In-Reply-To: <1201795051.3131.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

On Thu, 31 Jan 2008 09:57:31 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> No-one seems to see much value in these, and they cause about 90% of
> our problems with __init/__exit markers, so simply eliminate them.
> Rather than run over the whole tree removing them, this patch
> #defines them to be nops.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> I'll probably be going after __exit after this one, but it makes sense
> to split them up, since the hotplug annotation removal looks
> uncontroversial, whereas __exit and discard section removal might
> produce more robust debate.  I also think doing the hotplug removal
> gives us 90% of the benefits and removes 90% of the section mismatch
> problems.


Since hotplug is so fundamental nowadays the value no longer outweighs the pain/cost
to me, so 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
