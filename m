From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 16:08:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517160801.A9431@infradead.org>
References: <20030516182039.A7369@lst.de> <20030516235718.GA3260@beaverton.ibm.com> <Pine.LNX.4.52.0305171248460.4436@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:21257 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261564AbTEQOzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 10:55:16 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.52.0305171248460.4436@kai.makisara.local>; from Kai.Makisara@kolumbus.fi on Sat, May 17, 2003 at 12:59:59PM +0300
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, May 17, 2003 at 12:59:59PM +0300, Kai Makisara wrote:
> However, when I add to this Christoph's patch to change probing, I don't
> find any tapes any more. What I did was to first modprobe aic7xxx.
> According to dmesg, the device was found:
> 
> (scsi2:A:5): 10.000MB/s transfers (10.000MHz, offset 8)
>   Vendor: HP        Model: C1533A            Rev: 9608
>   Type:   Sequential-Access                  ANSI SCSI revision: 02
> Attached scsi generic sg0 at scsi2, channel 0, id 5, lun 0,  type 1
> 
> It did not appear in /sysfs/bus/scsi/devices (the system disk and the
> cdrom were there):

That exactly what I said in my mail to Douglas before - now there always
is one driver for each device.  If you have sg loaded but not st (yet)
sg will claim your tapes, not st.

