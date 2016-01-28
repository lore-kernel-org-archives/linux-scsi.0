From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
Date: Wed, 27 Jan 2016 22:00:59 -0800
Message-ID: <1453960859.2322.58.camel@HansenPartnership.com>
References: <1441706801-15300-1-git-send-email-olaf@aepfle.de>
	 <BY2PR0301MB16540206D42C1E00EC353D0EA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
	 <1443732718.6886.23.camel@HansenPartnership.com>
	 <20151002171415.GA30430@gmail.com> <20160125083514.GA11991@gmail.com>
	 <BY2PR0301MB1654E0BA47F3D2CC6D83BD64A0D90@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BY2PR0301MB1654E0BA47F3D2CC6D83BD64A0D90@BY2PR0301MB1654.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Olaf Hering <olaf@aepfle.de>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-27 at 23:09 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Monday, January 25, 2016 12:35 AM
> > To: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; linux-kernel@vger.kernel.org; linux-
> > scsi@vger.kernel.org
> > Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
> > 
> > On Fri, Oct 02, Olaf Hering wrote:
> > 
> > > On Thu, Oct 01, James Bottomley wrote:
> > > 
> > > > On Thu, 2015-10-01 at 20:30 +0000, KY Srinivasan wrote:
> > > 
> > > > > > +#if defined(CONFIG_X86_32)
> > > 
> > > > Um, this is a bit architecture specific (I know Azure is x86,
> > > > but
> > > > still).  Can you make the define check CONFIG_32BIT rather than
> > > > CONFIG_X86_32?
> > > 
> > > According to arch/x86/Kconfig there is no such thing.
> > 
> > What is the status of this change? Looks like there is nothing more 
> > to do on my side.
> 
> Olaf,
> 
> We do have the config option: CONFIG_X86_64. Perhaps we could use 
> this. Could you resubmit the patch with this change.

It's not really architecture independent, is it?  Just use the bit
width config.

James
