From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Date: Fri, 2 Mar 2012 21:22:38 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B736783@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
 <20120302211354.GB6008@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120302211354.GB6008@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, March 02, 2012 4:14 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > Windows hosts don't handle the ATA_16 command; don't pass it to the host.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Should this go to older kernel versions as well?

I think it should. Do you want me to resend this patch with the correct tag?
Also, given that storvsc has changed so much over the last several months,
this patch may or may not apply to earlier versions of this driver even though
this patch itself is quite trivial.

Regards,

K. Y
