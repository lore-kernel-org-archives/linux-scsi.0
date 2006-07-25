From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: fibre channel sync cache question
Date: Wed, 26 Jul 2006 00:39:54 +0200
Message-ID: <1153867194.8932.66.camel@laptopd505.fenrus.org>
References: <664A4EBB07F29743873A87CF62C26D70248ED4@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51388 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751601AbWGYWkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 18:40:03 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70248ED4@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: dougg@torque.net, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Michael Reed <mdr@sgi.com>

On Tue, 2006-07-25 at 16:28 -0600, Moore, Eric wrote:
> -- Tuesday, July 25, 2006 4:22 PM, Michael Reed wrote: 
> 
> > Using fibre channel disks, I've noticed that when the system 
> > shuts down
> > that the sd_driver issues a sync cache command to the device. 
> >  I've also
> > noticed that when the lldd is removed via rmmod that this 
> > sync cache is
> > not executed.  I would think that the sync cache would be desirable
> > under this circumstance.
> > 
> 
> This is not handled from sg path as well.  Meaning if you
> use sdparm, and enable the caching page WCE bit, then reboot,
> there is no SYNC cache issued from above. 
> 
> We handle this in fusion drivers due to short coming from above.


Hi,

that sounds sooo like the wrong approach... wouldn't it be better to fix
sg instead?


Greetings,
    Arjan van de Ven

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com

