From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Kill SCSI_BH
Date: Sun, 16 Jun 2002 00:38:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D0C1641.DB0147F3@torque.net>
References: <20020616040111.P9435@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> 
> I'm not exactly clueful about the linux SCSI layer, but I'd really like
> to see old-style bottom halves die before 2.6.  Is there any reason why
> SCSI_BH can't simply be comverted to a tasklet?

Probably just another linux scsi subsystem anachronism.

> Andrew Morton kindly tested this patch for me and reports it works fine.
> I'd expect the Enterprise people to be thrilled by this as it increases
> scalability a touch (eg, SCSI handling is now not serialised against
> the serial port).

I applied the patch and it's running fine on this box.
See how it goes with some stress testing. So far so go...

Doug Gilbert
