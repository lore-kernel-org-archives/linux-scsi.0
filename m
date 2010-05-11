From: "Phil Reynolds" <phil-linux@tinsleyviaduct.com>
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
Date: Tue, 11 May 2010 18:21:28 +0100
Message-ID: <20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com>
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
	<4BE964C2.1010702@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BE964C2.1010702@turmel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Phil Turmel <pturmel-kernel@turmel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Quoting "Phil Turmel" <pturmel-kernel@turmel.org>:

> I have a similar chipset in my office server: 88SE6145.  If yours can run
> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel command
> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
> ahci built-in, and no initramfs, so I put the option in my grub.conf.)

Neither works for me unfortunately.

-- 
Phil Reynolds
email: phil-linux@tinsleyviaduct.com
Not subscribed to lkml - please CC replies to me

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
