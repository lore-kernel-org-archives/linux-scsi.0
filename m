From: christophe.varoqui@free.fr
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.3.0
Date: Mon, 11 Oct 2004 14:31:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097497874.416a7d124937f@imp1-q.free.fr>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <20041006095009.GD1542@marowsky-bree.de> <1097057920.4163c680eaee0@imp5-q.free.fr> <20041011120049.GQ4021@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:3037 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S268886AbUJKMbP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 08:31:15 -0400
In-Reply-To: <20041011120049.GQ4021@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Selon Lars Marowsky-Bree <lmb@suse.de>:

> > * /etc/udev/udev.rules
> >
> > from 0.3.0 and up, we don't touch it anymore
>
> That's very good indeed and actually makes configuration easier! Which
> udev version do you require though?
>
034+, because of scsi_id-0.6 dependancy
if scsi_id is packaged separately in Suse, min version goes down as low as dev.d
introduction (I don't know precisely what the number is).

> > these copy udev, multipath tools and config files to initrd when
> > mkinitrd is launched.
>
> Yes. I'm not yet sure how/if we are going to support booting from
> multipath root fs in SLES9, so this doesn't really affect me for the
> time being.
>
> I first will need to do a gap analysis and figure out where to go today
> ;-)
>
yes,
the hard decision is wether you want to rely on kpartx.

regards,
cvaroqui
