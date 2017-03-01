From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] mpt3sas: Avoid sleeping in interrupt context
Date: Wed, 1 Mar 2017 09:28:40 -0800
Message-ID: <20170301172840.GB3486@vader.DHCP.thefacebook.com>
References: <20170301170036.11540-1-bart.vanassche@sandisk.com>
 <20170301170458.GA3486@vader.DHCP.thefacebook.com>
 <1488388175.2699.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488388175.2699.7.camel@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 01, 2017 at 05:09:48PM +0000, Bart Van Assche wrote:
> On Wed, 2017-03-01 at 09:04 -0800, Omar Sandoval wrote:
> > Thanks, Bart, you can add
> > 
> > Tested-by: Omar Sandoval <osandov@fb.com>
> 
> Hello Omar,
> 
> Have you been able to test both code paths - scsi-mq enabled and scsi-mq
> disabled?
> 
> Thanks,
> 
> Bart.

Just tried on blk-mq and I didn't get the splat, seems to be fine.
