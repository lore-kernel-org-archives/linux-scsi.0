From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
Date: Thu, 28 Jan 2016 07:37:15 -0800
Message-ID: <1453995435.2342.10.camel@HansenPartnership.com>
References: <1441706801-15300-1-git-send-email-olaf@aepfle.de>
	 <BY2PR0301MB16540206D42C1E00EC353D0EA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
	 <1443732718.6886.23.camel@HansenPartnership.com>
	 <20151002171415.GA30430@gmail.com> <20160125083514.GA11991@gmail.com>
	 <BY2PR0301MB1654E0BA47F3D2CC6D83BD64A0D90@BY2PR0301MB1654.namprd03.prod.outlook.com>
	 <1453960859.2322.58.camel@HansenPartnership.com>
	 <20160128064822.GA12884@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160128064822.GA12884@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-01-28 at 07:48 +0100, Olaf Hering wrote:
> On Wed, Jan 27, James Bottomley wrote:
> 
> > It's not really architecture independent, is it?  Just use the bit
> > width config.
> 
> Again: which one? This driver is not for mips|powerpc|score|sh.

zgrep CONFIG_.*BIT /proc/config.gz
[...]
CONFIG_64BIT=y

James
