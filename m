From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Linux distribution versions
Date: Tue, 30 Apr 2002 19:59:01 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020430195901.E1284@mea-ext.zmailer.org>
References: <3CCE77BC.5090903@galileo.co.il> <20020430165005.B1284@mea-ext.zmailer.org> <3CCEB8E8.1000207@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CCEB8E8.1000207@galileo.co.il>; from rabeeh@galileo.co.il on Tue, Apr 30, 2002 at 06:31:52PM +0300
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@galileo.co.il>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Apr 30, 2002 at 06:31:52PM +0300, Rabeeh Khoury wrote:
> Hi,
> 
> Thank you for the detailed response.

> Matti Aarnio wrote
> >  The tone of the question is giving an impression of "I want to publish
> >  binary-only driver"..  maybe it is just my ears, nevertheless...
> >
> Well, it's just your ears :)
> 
> The reason for the question is that testing a driver under so much 
> distributions is not a simple task.
> 
> Think of the following distributions - RedHat 6.x / 7.x ,  Caldera ,   
> Mandrake    ,    SuSe     and lots others  ; and add to that testing 
> under i386 / ppc / mips / sparc etc ....

  No need to go quite that widely, I think.

  The configuration set for i386 is:
	SMP  on/off
	PAE  on/off

  That is, four versions.  Use the "new error handler" API,
  and the driver should work at 2.2 and at 2.5 series kernels
  too.   (Aside of current 2.4, that is.)

  Other processors don't come in this many system architecture
  flavours.  Essentially getting the four versions of i386,
  and one big-endian (e.g. UltraSPARC) to work will most likely
  produce working driver at all systems, and handle 64 bit ones
  as well.  It isn't quite the same as being tested at all systems,
  but after those five the surprises are very unlikely.


> Regards,
> Rabeeh

/Matti Aarnio
