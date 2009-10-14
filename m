From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Moving drivers into staging (was Re: [GIT PULL] SCSI fixes for
 2.6.32-rc3)
Date: Wed, 14 Oct 2009 10:13:59 -0400
Message-ID: <4AD5DCA7.5060704@emulex.com>
References: <1255097287.2934.21.camel@localhost.localdomain> <20091012130652.GB25464@elte.hu> <1255357148.2850.91.camel@localhost.localdomain> <20091012145453.GD4565@elte.hu> <20091012150911.GB1656@suse.de> <20091012154244.GA13323@elte.hu> <20091012232429.GA24254@suse.de> <43e72e890910131108m789110b4hc35e25601ad67bb7@mail.gmail.com> <20091014044519.GA19199@suse.de> <1255497575.1851.16.camel@Joe-Laptop.home> <20091014063308.GE784@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39791 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbZJNOP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 10:15:29 -0400
In-Reply-To: <20091014063308.GE784@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@suse.de>, "Luis R. Rodriguez" <mcgrof@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>



Ingo Molnar wrote:
> Yes, that's a real worry. Some time ago i suggested:
> 
>   drivers/staging/good/
>   drivers/staging/bad/
>   drivers/staging/ugly/
> 
>  good:  drivers that are to go upstream in the next cycle 
>  bad:   outgoing drivers being obsoleted or abandoned
>  ugly:  incoming messy drivers with active developers
> 
> The messaging of this looks nice and the names are short and obvious.
> 
> An added benefit is that this kind of separation makes it easy for 
> people interested in drivers/staging to follow the 'status' of drivers. 
> Once stuff goes into 'good' a different kind of review is needed than if 
> a driver goes into 'ugly'.
> 
> The main disadvantage would be the PR angle: putting new drivers into a 
> path named 'ugly'. Not something you want to put into a quarterly status 
> report, right? If we put drivers/staging/ugly/ drivers into 
> drivers/staging/ itself, we'd solve that problem. I.e. we'd keep the 
> current scheme, but we'd also add drivers/staging/good/ and 
> drivers/staging/bad/ as two extra stages for incoming and outgoing 
> drivers.

Change "ugly" to "wip"  (work in progress).  Should remove the negative 
connotation and keeps things short. Does miss the spaghetti western theme
though :)

-- james s
