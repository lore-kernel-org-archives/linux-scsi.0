From: JiSheng Zhang <jszhang3@gmail.com>
Subject: Re: Is there any elegant way to re-identify and re-configure xfer mode
Date: Thu, 3 Nov 2011 14:31:16 +0800
Message-ID: <CADyp2Pfs_J6wY52tJsEpTANPgOiiMxK3oMW5LaZGL53Ym40yHQ@mail.gmail.com>
References: <CADyp2PdXeq8phoWSntyjGSY7dc93kcRg9DRV6cdCWi96j5g2LA@mail.gmail.com>
	<CAOS58YPxZSdGWT+3Wgo7mvrL0xzJE-F7WGKC7LryVUFuUe9xSQ@mail.gmail.com>
	<CADyp2PeT7hE2wy9ieqxOr3iJC5w_Zk0_pnmN51A0tUKk6VtKyg@mail.gmail.com>
	<CAOS58YNVaX=a9EH6ue48r6H5z7imJB5SwHd=B_W+m4ytX42keA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAOS58YNVaX=a9EH6ue48r6H5z7imJB5SwHd=B_W+m4ytX42keA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

2011/11/3 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Wed, Nov 2, 2011 at 11:03 PM, JiSheng Zhang <jszhang3@gmail.com> wrote:
>> It cause link reset, the cdrom go back to Boot mode again :(
>
> Umm... so the device goes to the 'basic' mode after reset and needs to
> be put into another mode for proper operation? If the hardware is
> designed that way, there really isn't much we can do about it.
> Supporting that requires changes to basic identify procedure and I'm
> strongly against such changes.
>
The difference between basic mode and normal mode is the xfer mode changes.
I just need to call ata_set_mode() after ata_dev_read_id() again. Is
it possible for
libata add and export such function?

Thanks for your help,
Jisheng
