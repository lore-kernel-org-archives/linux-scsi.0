From: Doug Ledford <dledford@redhat.com>
Subject: Re: aic7xxx_biosparam
Date: Sun, 17 Nov 2002 22:26:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118032600.GE4608@redhat.com>
References: <dledford@redhat.com> <20021118024645.GB4608@redhat.com> <200211180320.gAI3KBV16803@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211180320.gAI3KBV16803@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 09:20:10PM -0600, J.E.J. Bottomley wrote:
> > visible in  fdisk (well, after a module reload), so it get's used
> > somewhere.
> 
> The argument is that no user space tools rely on the cyls value, only the 
> sectors and heads.  They all use the GETGEO ioctl, but also get the blocksize 

That may very well be true and I'm all for that, but I'm still anal about 
being right anyway, so I implemented what Andries suggested.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
