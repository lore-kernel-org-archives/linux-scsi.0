From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Fri, 11 Nov 2011 09:36:33 -0800
Message-ID: <20111111173633.GA24351@suse.de>
References: <20111109162512.GB1260@google.com>
 <4EBD361E.5040106@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EBD361E.5040106@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 11, 2011 at 11:50:06PM +0900, Nao Nishijima wrote:
> Hi,
>=20
> Finally, I understood why this patch is not acceptable and would like=
 to
> solve the problem of the device name mismatch in *user space* using
> udev. So, could you please give me your comment about it?
>=20
> I aim to unify the device name because the name shown in command outp=
ut
> is different from it that users use for command execution.
>=20
> So, I'd like to suggest that two new API should be added to udev.
> - The API that returns any symlinks such as by-uuid, by id that users
>   selected before if a device name is given as arguments
>   If the commands directly access to proc filesystems, they cannot ge=
t
>   the symlinks. These commands should get the device name via this AP=
I.
> - The API that replaces device name to symlink in text messages
> =E3=80=80=E3=80=80The dmesg and syslog messages include the raw devic=
e names such as
>   sdX. They should be replaced with symlinks to unify the device name=
s.
> - udev support alias
>   Symlinks (by-uuid, by-id =E2=80=A6) is too long, compared to before=
 (e.g.
>   sdX). I guess most of users need more friendly and short names.
>=20
> Could you give me some advice or comments?
> (I will post this idea udev mailing list with prototype code)

Patches are always best to work off of, please post your changes to ude=
v
to the linux-hotplug list and we can take it from there.

thanks,

greg k-h
