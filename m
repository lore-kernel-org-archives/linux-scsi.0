From: Matthew Wilcox <willy@debian.org>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 18:45:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529174512.GU5850@parcelfarce.linux.theplanet.co.uk>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <20040529163641.GG31365@devserv.devel.redhat.com> <20040529164239.GA8855@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31700 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265274AbUE2RpN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:45:13 -0400
Content-Disposition: inline
In-Reply-To: <20040529164239.GA8855@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Arjan van de Ven <arjanv@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, May 29, 2004 at 12:42:39PM -0400, Alan Cox wrote:
> (If you want to argue about 2.7.x then its somewhat different - if scsi
>  devices appear in sysfs and the sysfs nodes also support SG_IO then the
>  entire notion of /dev/sg could go away in 2.7)

That would involve supporting ioctls in sysfs, which is something that's
been opposed so far.  I do agree that you want to flash disc firmware
using a hierarchical path rather than a flat namespace that you have
to double-check to be sure you're not flashing your scanner with disc
firmware.

Possibly we could have /sys/bus/scsi/devices/1\:0\:1\:0/raw_io that
internally uses the SG_IO codepath.  We'd need to rewrite the raw file
interface to support the large IOs necessary, but that's certainly doable.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
