From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: /proc/scsi/aic7xxx/? considered harmful (2.4.19-pre9)
Date: Thu, 6 Jun 2002 13:09:17 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15614.53853.52948.516366@notabene.cse.unsw.edu.au>
References: <15614.42400.697670.602385@notabene.cse.unsw.edu.au>
	<200206060254.g562sa935892@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: From notabene ([129.94.211.194] == dulcimer.orchestra.cse.unsw.EDU.AU)
	(for <gibbs@scsiguy.com>) (for <linux-scsi@vger.kernel.org>)
	(for <linux-kernel@vger.kernel.org>) By tone With Smtp ;
	Thu, 6 Jun 2002 13:09:16 +1000
In-Reply-To: message from Justin T. Gibbs on Wednesday June 5
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wednesday June 5, gibbs@scsiguy.com wrote:
> >
> >Hi,
> > I have 3 NFS servers with ext3 on raid5 on scsi with assorted
> >aic7xxx scsi controllers, all running 2.4.19-pre9 (plus some ext3 and
> >raid and nfs patches) using the "new" aic7xxx drivers.
> 
> You need to use aic7xxx driver version 6.2.8 to avoid this problem.
> Its been in Marcelo's tree for a bit, but I guess it missed pre9.

Thanks..  Looks like I have 6.2.6..
Actually on looking more closely it was -pre8, not -pre9 :-(

Anyway, I'm glad will be fixed in -final.  Thanks again,
NeilBrown
