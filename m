From: David Chaw <david.chaw@gmail.com>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [0/27]
Date: Thu, 17 Feb 2005 15:33:53 -0800
Message-ID: <73edde4605021715335275c27@mail.gmail.com>
References: <4214D5B1.1060701@adaptec.com> <1108673824.5507.32.camel@mulgrave>
	 <4215093C.3010702@adaptec.com>
Reply-To: David Chaw <david.chaw@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.206]:18879 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261242AbVBQXd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 18:33:57 -0500
Received: by wproxy.gmail.com with SMTP id 68so435845wra
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 15:33:53 -0800 (PST)
In-Reply-To: <4215093C.3010702@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>

Hi all,

Thanks for the all responses for this driver.
I really appreciate the comments / suggestions.
We definetely looking to making changes in the next few weeks.

Thanks again,

david


On Thu, 17 Feb 2005 16:14:36 -0500, Luben Tuikov
<luben_tuikov@adaptec.com> wrote:
> On 02/17/05 15:57, James Bottomley wrote:
> > Well, the initial reaction is yuk.
> >
> > Just from a brief glance over the files, the code is full of obfuscation
> > and unnecessary compatibility gunk which needs removing.
> >
> > It's also full of the same queueing junk that I asked be taken out of
> > the aic7xxx driver.
> 
> Thank you for all the comments guys!
> 
> > Then we get to the architectural stuff, which should really have been
> > discussed before you wrote the driver, not after
> 
> Just for the record: I did *not* write this driver!  I was merely given
> it to present it to the community.
> 
> > - We need a SAS and a PHY transport class.  Three of your files are to
> > do domain discover and should actually be part of the SAS transport
> > class.  In fact, it looks like a large amount of the code should be in
> > the various transport classes.
> 
> I absolutely agree.
> 
> > - The SATA pieces should use libata instead of trying to reinvent what
> > already exists.
> 
> I agree here as well.
> 
> Thanks for all the comments guys!
>        Luben
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
