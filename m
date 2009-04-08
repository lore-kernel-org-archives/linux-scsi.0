From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH 1/2 scsi-misc] qla1280: use request_firmware
Date: Wed, 08 Apr 2009 14:03:28 +0530
Message-ID: <1239179608.3940.3.camel@localhost.localdomain>
References: <1238654083.4940.8.camel@ht.satnam>
	 <1238654959.4940.12.camel@ht.satnam>  <20090408074342.GA3919@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763231AbZDHIeh@vger.kernel.org>
In-Reply-To: <20090408074342.GA3919@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jes Sorensen <jes@sgi.com>, David Woodhouse <dwmw2@infradead.org>, holt@sgi.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-04-08 at 00:43 -0700, Jeremy Higdon wrote:
> On Thu, Apr 02, 2009 at 12:19:19PM +0530, Jaswinder Singh Rajput wrote:
> > It seems LKML is rejected old email because of big size. so I am CC LKML
> > after deleting firmware blobs:
> > 
> > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Date: Thu, 2 Apr 2009 11:13:17 +0530
> > Subject: [PATCH] qla1280: use request_firmware
> > 
> > Firmware blob is little endian looks like this...
> >         unsigned char  Version1
> >         unsigned char  Version2
> >         unsigned char  Version3
> >         unsigned char  Padding
> >         unsigned short start_address
> > 	unsigned short data
> 
> This patch causes a problem.  It looks as though the firmware file may be
> incorrectly built for at least 12160.  We get a checksum error from the
> ISP12160 when it does the checksum:
> 

David, Jeremy: Thanks for the fix
http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=commitdiff;h=0ce49d6da993adf8b17b7f3ed9805ade14a6a6f3

--
JSR
