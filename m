From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH v3] storvsc: use small sg_tablesize on x86
Date: Fri, 10 Jun 2016 00:01:20 +0200
Message-ID: <20160609220120.GA28607@aepfle.de>
References: <20160609162553.10290-1-olaf@aepfle.de>
 <1465493159.2259.14.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465493159.2259.14.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 09, James Bottomley wrote:

> On Thu, 2016-06-09 at 18:25 +0200, Olaf Hering wrote:
> > Reducing the sg_tablesize allows booting of 32bit kernels in VMs,
> > after
> > commit be0cf6ca301c61458dc4aa1a37acf4f58d2ed3d6 ("scsi: storvsc: Set
> > the
> > tablesize based on the information given by the host")
> > 
> > [    5.567138] hv_storvsc vmbus_1: adjusting sg_tablesize 0x800 -> 
> > 0x20
> 
> Are you really sure 32 is the correct size?

Its a size that works, while the current state does not work at all.

> I know 32 it what it had before, but the reason for the commit you
> quote was to improve performance ...

The commit above broke 32bit. Whoever wants to improve performance on
this dead horse can submit another patch.

Olaf
