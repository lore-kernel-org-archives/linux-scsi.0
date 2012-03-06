From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [BUG] scsi_device.device == NULL in sd_revalidate_disk()
Date: Mon, 5 Mar 2012 16:11:46 -0800
Message-ID: <20120306001146.GA31227@localhost>
References: <20120305234133.GA13690@localhost>
 <CA+5PVA4axkm-S5-E1pnkgNpDLy3DHegFL2Cfo2i-8HOsfGMHDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA4axkm-S5-E1pnkgNpDLy3DHegFL2Cfo2i-8HOsfGMHDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@gmail.com>
Cc: "linux-fsdevel@vger.kernel.o..." <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 05, 2012 at 07:02:08PM -0500, Josh Boyer wrote:
> On Mon, Mar 5, 2012 at 6:41 PM, Fengguang Wu <fengguang.wu@intel.com>=
 wrote:
> > Hi,
> >
> > I ran into a NULL dereference bug on USB key hot remove, which shou=
ld
> > be caused by the below skdp->device reference
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0static int sd_revalidate_disk(struct gen=
disk *disk)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_=
disk *sdkp =3D scsi_disk(disk);
> > =3D=3D> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct scsi_devic=
e *sdp =3D sdkp->device;
>=20
> This has been reported numerous times.  There are patches to the bloc=
k layer
> that are supposed to fix it, but they haven't hit Linus' tree yet.  I=
 think
> we're waiting on Jens to push them.

OK, thanks for the information!

Thanks,
=46engguang
