From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Re[2]: ata over ethernet question
Date: Wed, 11 May 2005 00:00:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0505102352430.9008@poirot.grange>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
 <1115236116.7761.19.camel@dhollis-lnx.sunera.com> <1104082357.20050504231722@dns.toxicfilms.tv>
 <1115305794.3071.5.camel@dhollis-lnx.sunera.com> <20050507150538.GA800@favonius>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:33252 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261833AbVEJWBw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2005 18:01:52 -0400
In-Reply-To: <20050507150538.GA800@favonius>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sander <sander@humilis.net>
Cc: David Hollis <dhollis@davehollis.com>, Maciej Soltysiak <solt2@dns.toxicfilms.tv>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi

On Sat, 7 May 2005, Sander wrote:

> David Hollis wrote (ao):
> > There seem to be a few iSCSI implementations floating around for
> > Linux, hopefully one will be added to mainline soon. Most of those
> > implementations are for the client side though there is at least one
> > target implementation that allows you to provide local storage to
> > iSCSI clients. I don't remember the name of it or if it's still
> > maintained or not.
> 
> Quite active even:
> 
> http://sourceforge.net/projects/iscsitarget/
> 
> The "Quick Guide to iSCSI on Linux" is a good starting point btw.
> 
> Also check out http://www.open-iscsi.org/ (the client, aka 'initiator').

A follow up question - I recently used nbd to access a CD-ROM. It worked 
nice, but, I had to read in 7 CDs, so, each time I had to replace a CD, I 
had to stop the client, the server, then replace the CD, re-start the 
server, re-start the client... I thought about extending NBD to (better) 
support removable media, but then you start thinking about all those 
features that your local block device has that don't get exported over 
NBD...

Now, my understanding (sorry, without looking at any docs - yet) is, that 
iSCSI is (or at least should be) free from these limitations. So, does it 
make any sense at all extending NBD or just switch to iSCSI? Should NBD be 
just kept simple as it is or would it be completely superseeded by iSCSI, 
or is there still something that NBD does that iSCSI wouldn't (easily) do?

Or am I completely misunderstanding what iSCSI target does?

Thanks
Guennadi
---
Guennadi Liakhovetski

