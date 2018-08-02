From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: linux-next: Tree for Aug 1
Date: Thu, 2 Aug 2018 14:51:41 +0200
Message-ID: <20180802125141.jyb2zz75jgrzibaq@linux-x5ow.site>
References: <20180801175852.36549130@canb.auug.org.au>
 <20180801224813.GA13074@roeck-us.net>
 <1533163965.3158.1.camel@HansenPartnership.com>
 <20180801234727.GA3762@roeck-us.net>
 <CACVXFVMrzLRP5Q=cwZGnqeUeyODL3Pq9jMkT7czZouK9510fUA@mail.gmail.com>
 <1533168205.3158.12.camel@HansenPartnership.com>
 <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
 <e3e32fd801cb1270cddec6fc1ea3dabad4473b64.camel@wdc.com>
 <93cbb876-3a25-482a-a5b4-6e13d42ee535@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <93cbb876-3a25-482a-a5b4-6e13d42ee535@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 02, 2018 at 05:46:19AM -0700, Guenter Roeck wrote:
> This is consistent across multiple test runs. In summary,
> 
> - Boot from initrd fails
> - Boot from SATA drive fails (this is with CONFIG_ATA)
> - Boot from NVME fails
> - Boot from USB drive fails
> - Boot from MMC (SD) fails
> - Boot from USB UAS drive passes
> - Boot from various real SCSI drives passes
> 
> Platform (pc,q35), CPU type, or SMP/NOSMP does not seem to make a difference.

OK. I try to bisect between next-20180727 (known good) and
next-20180731 (known bad) with forced scsi_mod.use_blk_mq=1, but so
far the only bad I've seen is next-20180731.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
