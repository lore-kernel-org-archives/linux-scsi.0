From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 12:42:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529164239.GA8855@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <20040529163641.GG31365@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:4821 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264335AbUE2Qmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 12:42:47 -0400
Content-Disposition: inline
In-Reply-To: <20040529163641.GG31365@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Alan Cox <alan@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, May 29, 2004 at 06:36:42PM +0200, Arjan van de Ven wrote:
> > never include source code. The whole point of sg is arbitary management of
> > devices. 
> 
> *AND SG_IO IS THAT*. You seem to ignore that consistently.

Unfortunately my devices randomly change name according to what is loaded

> those commands, with the same ioctl. THAT changed. Don't tell me that very
> long list of third party apps ALL doesn't take a device as argument....
> undoubtedly several don't but... "long list"...

I had to recompile my kernel to flash my scsi drive firmware. It works
in the generic kernel but not in 2.6.5-Fedora. That alone says its not
an acceptable change for a "stable" kernel tree - which hopefully 2.6.x
will become in the next six months.

(If you want to argue about 2.7.x then its somewhat different - if scsi
 devices appear in sysfs and the sysfs nodes also support SG_IO then the
 entire notion of /dev/sg could go away in 2.7)


