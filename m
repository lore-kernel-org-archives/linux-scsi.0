From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: linux-next: manual merge of the scsi-mkp tree with the char-misc
 tree
Date: Fri, 7 Apr 2017 08:49:14 -0700
Message-ID: <47b500d6-0700-812f-dda3-44a14014b66e@sandisk.com>
References: <20170407153351.0ecafd59@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20170407153351.0ecafd59@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Logan Gunthorpe <logang@deltatee.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/06/2017 10:33 PM, Stephen Rothwell wrote:
> Hi Martin,
> 
> Today's linux-next merge of the scsi-mkp tree got a conflict in:
> 
>   drivers/scsi/osd/osd_uld.c
> 
> between commit:
> 
>   ac1ddc584e98 ("scsi: utilize new cdev_device_add helper function")
> 
> from the char-misc tree and commit:
> 
>   c02465fa13b6 ("scsi: osd_uld: Check scsi_device_get() return value")
> 
> from the scsi-mkp tree.
> 
> I am not sure how to resolve this, so I have just effectively recerted
> the latter commit fo today.  Better suggestions welcome.
> 
> I fixed it up and can carry the fix as necessary. This is now fixed as
> far as linux-next is concerned, but any non trivial conflicts should be
> mentioned to your upstream maintainer when your tree is submitted for
> merging.  You may also want to consider cooperating with the maintainer
> of the conflicting tree to minimise any particularly complex conflicts.

(+linux-scsi)

Hello Martin,

Sorry that I had not yet noticed Logan's patch series. Should my two
patches that conflict with Logan's patch series be dropped and reworked
after Logan's patches are upstream?

Thanks,

Bart.
