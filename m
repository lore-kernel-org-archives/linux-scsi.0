From: JiSheng Zhang <jszhang3@gmail.com>
Subject: Re: Is there any elegant way to re-identify and re-configure xfer mode
Date: Thu, 3 Nov 2011 14:03:09 +0800
Message-ID: <CADyp2PeT7hE2wy9ieqxOr3iJC5w_Zk0_pnmN51A0tUKk6VtKyg@mail.gmail.com>
References: <CADyp2PdXeq8phoWSntyjGSY7dc93kcRg9DRV6cdCWi96j5g2LA@mail.gmail.com>
	<CAOS58YPxZSdGWT+3Wgo7mvrL0xzJE-F7WGKC7LryVUFuUe9xSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAOS58YPxZSdGWT+3Wgo7mvrL0xzJE-F7WGKC7LryVUFuUe9xSQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun

2011/11/2 Tejun Heo <tj@kernel.org>:
> From userland,
>
> # echo - - - > /sys/class/scsi_host/hostX/rescan
>

There's no action after echo --- > /sys/class/scsi_host/hostX/scan

> From kernel,
>
> =A0 =A0spin_lock_irqsave(ap->lock, flags);
> =A0 =A0dev->link.eh_info.dev_action[dev->devno] |=3D ATA_EH_REVALIDAT=
E;
> =A0 =A0ata_port_schedule_eh(ap);
> =A0 =A0spin_unlock_irqrestore(ap->lock, flags);

It cause link reset, the cdrom go back to Boot mode again :(

would you plz give any suggestions?

Thanks very much,
Jisheng
