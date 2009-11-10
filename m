From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi_lib_dma.c :  fix bug with dma maps on nested scsi
 objects - (2nd try)
Date: Tue, 10 Nov 2009 09:38:45 -0500
Message-ID: <4AF97AF5.2090700@emulex.com>
References: <1257295546.5965.7.camel@wookie> <1257449592.10355.26.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1257449592.10355.26.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

James,

This updated patch works fine for lpfc and our vports...

Acked-By: James Smart  <james.smart@emulex.com>

-- james s


James Bottomley wrote:
> 
> 141 lines plus a static list to solve a simple problem is getting a bit
> icky to say the least.
> 
> What about being more simplistic and simply making the host cache a
> pointer to the physical bus device?  I probably objected to this a long
> time ago because using the parent pointers is more elegant, but I think
> this patch demonstrates conclusively it's not worth this amount of code
> for the sake of alleged elegance.
> 
> James
> 
> ---
>  drivers/scsi/hosts.c            |   13 ++++++++++---
>  drivers/scsi/lpfc/lpfc_init.c   |    2 +-
>  drivers/scsi/qla2xxx/qla_attr.c |    3 ++-
>  drivers/scsi/scsi_lib_dma.c     |    4 ++--
>  include/scsi/scsi_host.h        |   16 +++++++++++++++-
>  5 files changed, 30 insertions(+), 8 deletions(-)
