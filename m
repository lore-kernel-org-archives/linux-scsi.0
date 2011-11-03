From: Tejun Heo <tj@kernel.org>
Subject: Re: Is there any elegant way to re-identify and re-configure xfer mode
Date: Wed, 2 Nov 2011 23:10:16 -0700
Message-ID: <CAOS58YNVaX=a9EH6ue48r6H5z7imJB5SwHd=B_W+m4ytX42keA@mail.gmail.com>
References: <CADyp2PdXeq8phoWSntyjGSY7dc93kcRg9DRV6cdCWi96j5g2LA@mail.gmail.com>
	<CAOS58YPxZSdGWT+3Wgo7mvrL0xzJE-F7WGKC7LryVUFuUe9xSQ@mail.gmail.com>
	<CADyp2PeT7hE2wy9ieqxOr3iJC5w_Zk0_pnmN51A0tUKk6VtKyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CADyp2PeT7hE2wy9ieqxOr3iJC5w_Zk0_pnmN51A0tUKk6VtKyg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Wed, Nov 2, 2011 at 11:03 PM, JiSheng Zhang <jszhang3@gmail.com> wrote:
> It cause link reset, the cdrom go back to Boot mode again :(

Umm... so the device goes to the 'basic' mode after reset and needs to
be put into another mode for proper operation? If the hardware is
designed that way, there really isn't much we can do about it.
Supporting that requires changes to basic identify procedure and I'm
strongly against such changes.

Good luck.

-- 
tejun
