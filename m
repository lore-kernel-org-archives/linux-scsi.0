From: Jens Axboe <axboe@suse.de>
Subject: Re: I/O performance measurement tools on Linux
Date: Wed, 29 Mar 2006 09:13:07 +0200
Message-ID: <20060329071306.GP8186@suse.de>
References: <890BF3111FB9484E9526987D912B261901BC88@NAMAIL3.ad.lsil.com> <4429F9F9.9000403@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:53794 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751122AbWC2HNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 02:13:08 -0500
Content-Disposition: inline
In-Reply-To: <4429F9F9.9000403@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>, "Ju, Seokmann" <Seokmann.Ju@engenio.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 28 2006, Douglas Gilbert wrote:
> Ju, Seokmann wrote:
> > Hi,
> > 
> > Are there any performance measurement tools available that running on
> > Linux?
> > I would like to measure disk I/O performance (file system and raw I/O)
> > on several kernels.
> > Please lead me to the place.
> 
> The sg3_utils package may help with some raw SCSI
> and SATA disk I/O measurements.
> sg_dd, sgp_dd and sgm_dd are dd variants that
> let you tweak a lot of low level details. The sg_read
> utility can be used to measure disk cache throughput,
> transport speeds and command overhead.

I wrote a little fio tool that can be used as well, it can use various
types of io engines: libaio, posixaio, regular sync io, direct io, and
SG_IO io. You can write simple job files for it, there are some examples
included in the tar ball.

http://brick.kernel.dk/snaps/

Just grab the latest snapshot, that's usually the least buggy version
:-)

-- 
Jens Axboe

