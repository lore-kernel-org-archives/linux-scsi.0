From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH]: Flexible timeout infrastructure
Date: Wed, 16 Jun 2004 13:10:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F94F0@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53998 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264197AbUFPRLg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:11:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I can appreciate the protectionist point of view. My only contention is -
how do you really derive that 1 reset is any less valid than 2 ? it totally
depends on what the original timeout was relative to whatever the duration
is for the LLDD event that is requesting the reset. 

-- James

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Wednesday, June 16, 2004 1:04 PM
> To: Smart, James
> Cc: Luben Tuikov; Mike Anderson; SCSI Mailing List
> Subject: RE: [PATCH]: Flexible timeout infrastructure
> 
> 
> On Wed, 2004-06-16 at 11:58, Smart, James wrote:
> > So why increment the retries counter at all ? 
> 
> So drivers can't return EH_RESET_TIMER forever. This really ties the
> handling into the behaviour the user has requested.  The only wrinkle
> was the no retry streaming commands.  The assumption is that a retry
> doesn't actually happen under eh_timed_out, but only an attempt to
> collect an existing command which may be delayed because of 
> transport or
> other problems the host knows about.
> 
> James
> 
> 
