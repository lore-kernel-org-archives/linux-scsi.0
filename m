From: "John Stoffel" <john@stoffel.org>
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
Date: Tue, 11 May 2010 15:14:11 -0400
Message-ID: <19433.44163.776781.931987@stoffel.org>
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
	<4BE964C2.1010702@turmel.org>
	<20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Phil Reynolds <phil-linux@tinsleyviaduct.com>
Cc: Phil Turmel <pturmel-kernel@turmel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Phil" == Phil Reynolds <phil-linux@tinsleyviaduct.com> writes:

Phil> Quoting "Phil Turmel" <pturmel-kernel@turmel.org>:
>> I have a similar chipset in my office server: 88SE6145.  If yours can run
>> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel command
>> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
>> ahci built-in, and no initramfs, so I put the option in my grub.conf.)

Phil> Neither works for me unfortunately.

Can you post your dmesg output from both bootups?  Are there any
differences?  Also submit the lspci -vvv output as well, just so
people can help you better.

John
