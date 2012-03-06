From: Josh Boyer <jwboyer@gmail.com>
Subject: Re: [BUG] scsi_device.device == NULL in sd_revalidate_disk()
Date: Mon, 5 Mar 2012 19:02:08 -0500
Message-ID: <CA+5PVA4axkm-S5-E1pnkgNpDLy3DHegFL2Cfo2i-8HOsfGMHDw@mail.gmail.com>
References: <20120305234133.GA13690@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120305234133.GA13690@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.o..." <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 5, 2012 at 6:41 PM, Fengguang Wu <fengguang.wu@intel.com> w=
rote:
> Hi,
>
> I ran into a NULL dereference bug on USB key hot remove, which should
> be caused by the below skdp->device reference
>
> =A0 =A0 =A0 =A0static int sd_revalidate_disk(struct gendisk *disk)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct scsi_disk *sdkp =3D scsi_disk(d=
isk);
> =3D=3D> =A0 =A0 =A0 =A0 =A0 =A0 struct scsi_device *sdp =3D sdkp->dev=
ice;

This has been reported numerous times.  There are patches to the block =
layer
that are supposed to fix it, but they haven't hit Linus' tree yet.  I t=
hink
we're waiting on Jens to push them.

josh
