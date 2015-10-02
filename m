From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
Date: Fri, 2 Oct 2015 19:14:15 +0200
Message-ID: <20151002171415.GA30430@gmail.com>
References: <1441706801-15300-1-git-send-email-olaf@aepfle.de>
 <BY2PR0301MB16540206D42C1E00EC353D0EA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
 <1443732718.6886.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443732718.6886.23.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 01, James Bottomley wrote:

> On Thu, 2015-10-01 at 20:30 +0000, KY Srinivasan wrote:

> > > +#if defined(CONFIG_X86_32)

> Um, this is a bit architecture specific (I know Azure is x86, but
> still).  Can you make the define check CONFIG_32BIT rather than
> CONFIG_X86_32?

According to arch/x86/Kconfig there is no such thing.

Olaf
