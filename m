From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 10:39:41 -0400
Message-ID: <49F07DAD.7080107@garzik.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <d14109aa6209be628074.1240464572@sermon.lab.mkp.net> <20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org> <20090423113841.GK1926@parisc-linux.org> <yq1r5zjbje2.fsf@sermon.lab.mkp.net> <49F06E3B.104@garzik.org> <1240495814.3514.8.camel@mulgrave.int.hansenpartnership.com> <20090423141644.GP1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090423141644.GP1926@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Apr 23, 2009 at 02:10:13PM +0000, James Bottomley wrote:
>> I'm with Jeff on this one.  We had an identically similar problem with
>> REPORT LUNS, which, today is the basis of SCSI discovery.
> 
> Yes, REPORT LUNS is quite essential.
> 
> It's not exactly in the same category as reporting device form factor
> and rotational speed.  If REPORT LUNS is wrong, we're in really deep
> trouble.  If device form factr is wrong ... umm ... nothing much happens.
> If rotational speed is wrong, we might have a suboptimal IO pattern.

If the general attitude is "oh, that info might be wrong", why will app 
developers bother at all?

It is better to return zeroes than have a decent probability of 
returning garbage.  I value predictability much more than adopting a 
generalized rule to handle a few special case early adopters.


> It's also fixable by udev.

By that logic we should leave it to udev to handle the ata_version <= 7 
stuff, since that is the early adopter special case.

	Jeff



