From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [0/27]
Date: Thu, 17 Feb 2005 16:14:36 -0500
Message-ID: <4215093C.3010702@adaptec.com>
References: <4214D5B1.1060701@adaptec.com> <1108673824.5507.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:35750 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261165AbVBQVOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 16:14:41 -0500
In-Reply-To: <1108673824.5507.32.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 02/17/05 15:57, James Bottomley wrote:
> Well, the initial reaction is yuk.
> 
> Just from a brief glance over the files, the code is full of obfuscation
> and unnecessary compatibility gunk which needs removing.
> 
> It's also full of the same queueing junk that I asked be taken out of
> the aic7xxx driver.

Thank you for all the comments guys!
 
> Then we get to the architectural stuff, which should really have been
> discussed before you wrote the driver, not after

Just for the record: I did *not* write this driver!  I was merely given
it to present it to the community.
 
> - We need a SAS and a PHY transport class.  Three of your files are to
> do domain discover and should actually be part of the SAS transport
> class.  In fact, it looks like a large amount of the code should be in
> the various transport classes.

I absolutely agree.
 
> - The SATA pieces should use libata instead of trying to reinvent what
> already exists.

I agree here as well.

Thanks for all the comments guys!
	Luben
