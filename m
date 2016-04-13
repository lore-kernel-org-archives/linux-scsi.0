From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [-next] BUG_ON in scsi_target_destroy()
Date: Wed, 13 Apr 2016 15:59:31 +0200
Message-ID: <1517391.Uqi4c4PsRt@c203>
References: <20160411090146.GA537@swordfish> <2201725.I2to9GCRQJ@c203> <20160413144704.GA490@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160413144704.GA490@swordfish>
Sender: linux-next-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-next@vger.kernel.org, Xiong Zhou <jencce.kernel@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mittwoch, 13. April 2016 23:47:04 CEST Sergey Senozhatsky wrote:
> Hi,
>=20
> On (04/13/16 10:41), Johannes Thumshirn wrote:
> > Hi Sergey,  Xiong,
> >=20
> > Can you try below patch?
>=20
> it panics my system.
> first it warn_on-s in lib/kobject.c:244
>=20
> then NULL dereferences
> do_scan_async
>  __scsi_remove_device
>   scsi_target_reap
>    device_del
>     dpm_sysfs_remove
>      sysfs_unmerge_group
>       kernfs_find_and_get_ns
>        kernfs_find_ns
>=20
> 	-ss
>=20

Thanks for the update, I'll have a look into the callchain

--=20
Johannes Thumshirn                                                     =
                           Storage
jthumshirn@suse.de                                                     =
        +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
