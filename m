From: Doug Ledford <dledford@redhat.com>
Subject: Re: BT930 + old scsi disk
Date: Fri, 26 Apr 2002 14:11:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020426141104.A20362@redhat.com>
References: <20020426125655.A1961@grobbebol.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020426125655.A1961@grobbebol.xs4all.nl>; from scsi@grobbebol.xs4all.nl on Fri, Apr 26, 2002 at 12:56:55PM +0000
List-Id: linux-scsi@vger.kernel.org
To: "Roeland Th. Jansen" <scsi@grobbebol.xs4all.nl>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 26, 2002 at 12:56:55PM +0000, Roeland Th. Jansen wrote:
> I heard the following sound (yep, technical ahum) :
> 
> click
> downspin....
> click
> upspin......

This is almost always a power related problem or drive failure problem, 
not a kernel problem.  The fact that your machine hard locked at the same 
time would make me thing it's your power supply about to go out or that 
you weren't on a battery backup and you got a bad enough brown out to 
cause the machine to loose enough power to lock up and the drive to spin 
down.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
