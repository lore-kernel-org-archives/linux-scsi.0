From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [dm-devel] Re: Is there a grand plan for FC failover?
Date: Thu, 12 Feb 2004 11:03:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040212110302.G27680@vienna.EGENERA.COM>
References: <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM> <20040128124756.A7232@beaverton.ibm.com> <1075328066.2534.10.camel@mulgrave><20040130194826.GC31596@reti> <20040131115903.A4881@vienna.EGENERA.COM> <20040212101705.F27680@vienna.EGENERA.COM> <1076599721.4442.4.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:33488 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S266334AbUBLQFw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 11:05:52 -0500
Content-Disposition: inline
In-Reply-To: <1076599721.4442.4.camel@laptop.fenrus.com>; from arjanv@redhat.com on Thu, Feb 12, 2004 at 04:28:41PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Rumor has it that on Thu, Feb 12, 2004 at 04:28:41PM +0100 Arjan van de Ven said:
> 
> > That size is based on the blocksize? Is there a way to set the block size higher than
> > 512 w/o mounting it? I've gotten really bad rawio performance on 2.4. since I have a 
> > limit of 32 sg entries. When Rawio uses a 512 byte blocksize IOs are limited to 16K. 
> > 
> > Will this still be a problem in 2.6?
> 
> If you code the driver right, it's not even a problem in 2.4 if you use
> a Enterprise Linux distro kernel.....
> 

Hi Arjan, I think you know that I do use your Enterprise kernel :)

Can you please explain what "right" means in this case?

I've a hardware limit of 32 sg entries. When the blocksize is the default hardware
sector size of 512 I get commands of 32 separate 512 bytes scatter-gather entries.
This is deteremined at a higher level than my LLDD. What is there that I can do 
about it in the driver?


Cheers,

Phil


-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
