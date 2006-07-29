From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 00:13:06 +0200
Message-ID: <1154211186.2903.66.camel@laptopd505.fenrus.org>
References: <20060729045249.GA23398@redhat.com>
	 <20060729111240.GG13095@suse.de>
	 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
	 <44CBAB4B.7050308@torque.net>
	 <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org>
	 <44CBC115.2080401@torque.net>
	 <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
	 <Pine.LNX.4.64.0607291338530.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:24030 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750861AbWG2WNK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 18:13:10 -0400
In-Reply-To: <Pine.LNX.4.64.0607291338530.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org, Dave Jones <davej@redhat.com>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>


> (As a historical oddity - there _was_ this bug in some drive that would 
> corrupt the firmware by mistake, though - I think we _did_ actually fry 
> some drives by sending it a "cache flush" command that it wasn't 
> expecting, and that it turned into firmware reload thing or something. I 
> think Alan Cox knows all the gruesome details, but that we could 
> definitely blame on bad hardware..

since you asked for it...

a certain distribution shipped a preproduction version of a packet
writing patch or it was some barrier thing, I forgot, which would end up
sending an *ATA* "cache flush" command to ATAPI drives that didn't claim
to understand that command range. A certain model of cdrom drive (LG?)
actually had that same command byte code as "flash firmware". 

Arguably it's a very stupid value to pick, but it's also not technically
a drive bug; the drive explicitly claimed to not understand the command
set in question, and that distro kernel sent it anyway. 


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com

