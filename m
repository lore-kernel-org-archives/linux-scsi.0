From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Properly handle errors from
 the host
Date: Mon, 2 Apr 2012 23:09:54 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF90238C1@BY2PRD0310MB378.namprd03.prod.outlook.com>
References: <1333065283-30484-1-git-send-email-kys@microsoft.com>
 <20120329235111.GA19924@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120329235111.GA19924@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, March 29, 2012 7:51 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Properly handle errors from the
> host
> 
> On Thu, Mar 29, 2012 at 04:54:43PM -0700, K. Y. Srinivasan wrote:
> > If the host returns error for pass through commands, deal with
> > appropriately. I would like to thank James for patiently helping
> > me with this patch.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c |   20 ++++++++++++++++----
> >  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> As this driver is now in Linus's tree, and drivers/scsi/ is James's
> area, he is the one to take them, not me.

Thanks Greg; I understand James would be responsible for deciding if
this patch is the correct way to fix this issue and to check this patch in, if it is.

Regards,

K. Y
