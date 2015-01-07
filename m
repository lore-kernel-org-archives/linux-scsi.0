From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Wed, 7 Jan 2015 15:37:05 +0100
Message-ID: <20150107143705.GA888@lst.de>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de> <1420583956.6927.61.camel@haakon3.risingtidesystems.com> <20150107143150.GC659@lst.de> <54AD4389.6030107@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AD4389.6030107@profihost.ag>
Sender: target-devel-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 07, 2015 at 03:32:41PM +0100, Stefan Priebe - Profihost AG wrote:
> > If I understand Stefan correct he was using a recent 3.19-rc kernel,
> > which contains my commit in the subject that stops capping the
> > max_sectors used by the kernel below that which the hardware supports.
> > 
> > Given that LIO actually implements the block limits EVPD that suggests
> > we're not properly using that information.
> > 
> > Stefant, what does:
> > 
> > sg_vpd -p bl /dev/sdX
> > 
> > for the LIO device tell?
> 
> I'm sorry i'm using a 3.10.63 vanilla kernel. So i'm missing a commit?

You said "block: remove artifical max_hw_sectors cap" causes the I/O
errors for you, which should only be in a 3.19-ish kernel.
