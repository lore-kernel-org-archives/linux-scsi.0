From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Mon, 27 Aug 2007 04:03:10 +0200
Message-ID: <20070827020310.GC4121@stusta.de>
References: <200708252257.07241.vda.linux@googlemail.com> <20070825145742.69b99168@laptopd505.fenrus.org> <200708261621.30563.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56707 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753786AbXH0CDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Aug 2007 22:03:12 -0400
Content-Disposition: inline
In-Reply-To: <200708261621.30563.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de

On Sun, Aug 26, 2007 at 04:21:30PM +0100, Denys Vlasenko wrote:
> On Saturday 25 August 2007 22:57, Arjan van de Ven wrote:
>...
> > Did you run the find static
> > script or are you waiting for Adrian to do that ;-)
> 
> $ find -name '*find*static*'
> $

  make namespacecheck

> vda

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

