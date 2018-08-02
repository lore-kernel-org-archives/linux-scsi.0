From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: linux-next: Tree for Aug 1
Date: Thu, 2 Aug 2018 06:00:19 -0700
Message-ID: <b1616769-b1d7-97c7-b197-9dc3d0f74a7b@roeck-us.net>
References: <20180801175852.36549130@canb.auug.org.au>
 <20180801224813.GA13074@roeck-us.net>
 <1533163965.3158.1.camel@HansenPartnership.com>
 <20180801234727.GA3762@roeck-us.net>
 <CACVXFVMrzLRP5Q=cwZGnqeUeyODL3Pq9jMkT7czZouK9510fUA@mail.gmail.com>
 <1533168205.3158.12.camel@HansenPartnership.com>
 <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
 <e3e32fd801cb1270cddec6fc1ea3dabad4473b64.camel@wdc.com>
 <93cbb876-3a25-482a-a5b4-6e13d42ee535@roeck-us.net>
 <20180802125141.jyb2zz75jgrzibaq@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802125141.jyb2zz75jgrzibaq@linux-x5ow.site>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/02/2018 05:51 AM, Johannes Thumshirn wrote:
> On Thu, Aug 02, 2018 at 05:46:19AM -0700, Guenter Roeck wrote:
>> This is consistent across multiple test runs. In summary,
>>
>> - Boot from initrd fails
>> - Boot from SATA drive fails (this is with CONFIG_ATA)
>> - Boot from NVME fails
>> - Boot from USB drive fails
>> - Boot from MMC (SD) fails
>> - Boot from USB UAS drive passes
>> - Boot from various real SCSI drives passes
>>
>> Platform (pc,q35), CPU type, or SMP/NOSMP does not seem to make a difference.
> 
> OK. I try to bisect between next-20180727 (known good) and
> next-20180731 (known bad) with forced scsi_mod.use_blk_mq=1, but so
> far the only bad I've seen is next-20180731.
> 

Per my logs, next-20180730 is the first bad, next-20180727 is the last good.

Guenter
