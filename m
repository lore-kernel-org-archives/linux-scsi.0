From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
Date: Wed, 12 May 2010 02:01:28 -0400
Message-ID: <4BEA4438.4030608@garzik.org>
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com> <4BE964C2.1010702@turmel.org> <20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com> <4BE9A1B3.3020208@turmel.org> <4BE9C796.7080605@garzik.org> <4BEA0E54.4080208@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52911 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0ELGBa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 02:01:30 -0400
In-Reply-To: <4BEA0E54.4080208@turmel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Turmel <pturmel-kernel@turmel.org>
Cc: Phil Reynolds <phil-linux@tinsleyviaduct.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 05/11/2010 10:11 PM, Phil Turmel wrote:
> Hi Jeff,
>
> On 05/11/2010 05:09 PM, Jeff Garzik wrote:
>> On 05/11/2010 02:28 PM, Phil Turmel wrote:
>>> On 05/11/2010 01:21 PM, Phil Reynolds wrote:
>>>> Quoting "Phil Turmel"<pturmel-kernel@turmel.org>:
>>>>
>>>>> I have a similar chipset in my office server: 88SE6145.  If yours
>>>>> can run
>>>>> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel
>>>>> command
>>>>> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I
>>>>> have
>>>>> ahci built-in, and no initramfs, so I put the option in my grub.conf.)
>>>>
>>>> Neither works for me unfortunately.
>>>>
>
> [snip /]
>
>> sata_mv is not related to this hardware.
>>
>> pata_marvell works with 6101/6121/6141/6145 PATA ports.
>>
>> ahci works with 6101/6121/6141/6145 SATA ports, with marvell_enable=1.
>>
>>      Jeff
>
> I think you might have me (Phil T) confused with the original poster, Phil
> Reynolds [1].

No confusion.  You suggested blacklisting sata_mv, and I note above that 
sata_mv has nothing to do with the hardware in question.

	Jeff



