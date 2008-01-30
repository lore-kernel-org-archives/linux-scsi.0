From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] scsi/qlogicpti.c section fixes
Date: Wed, 30 Jan 2008 23:30:30 +0200
Message-ID: <20080130213030.GR29368@does.not.exist>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58367 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYA3V34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 16:29:56 -0500
Content-Disposition: inline
In-Reply-To: <20080130212011.GA26621@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 10:20:11PM +0100, Sam Ravnborg wrote:
> On Wed, Jan 30, 2008 at 03:00:16PM -0600, James Bottomley wrote:
>...
> To my understanding Adrian just fixed a potential oops.
> You have a driver that surely are thought to be hotplugable -
> otherwise qpti_sbus_probe() would not have been annotated __devinit.
> And had it ever been hotplugged then you had called a function in
> a __init section that was long gone.
>...

s/had it ever been hotplugged/had it been hotplugged with a kernel
                              compiled with gcc 3.2 or 3.3/

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

