From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Thu, 16 Jun 2011 21:03:43 +0900
Message-ID: <4DF9F11F.705@hitachi.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110615153337.GA10160@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

(2011/06/16 0:33), Greg KH wrote:
> On Wed, Jun 15, 2011 at 05:16:28PM +0900, Nao Nishijima wrote:
>> Allow users to set the preferred name of device via sysfs interface.
>>
>> (Exsample) sda -> foo
>> # echo foo > /sys/block/sda/preferred_name
>>
>> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com=
>
>> Suggested-by: Jon Masters <jcm@redhat.com>
>> Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
>=20
> You don't document this new sysfs file (which is required), nor do yo=
u
> explain what it is for and how to use it.
>=20
> Please do that in this patch, and in a Documentation/ABI/ file for an=
y
> new sysfs file you create.
>

I'm afraid that my explanation was not enough.
I will add explanation to this patch and Documentation/ABI file.

> I still fail to understand how a "preferred" file will help anyone ou=
t
> here at all...
>

Let me explain, users cannot identify a device from a device name
because device names may change at each boot up time. If kernel show
preferred names in kernel messages, users can easily identify a device
from kernel messages.

> greg k-h
>=20

Thanks,

--=20
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email=EF=BC=9A nao.nishijima.xt@hitachi.com
