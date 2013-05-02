From: Hannes Reinecke <hare@suse.de>
Subject: Re: linux-next: Tree for May 1
Date: Thu, 02 May 2013 09:46:05 +0200
Message-ID: <518219BD.9090208@suse.de>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au> <alpine.DEB.2.02.1305021529430.23933@M2420>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1305021529430.23933@M2420>
Sender: linux-next-owner@vger.kernel.org
To: ZX <jencce.kernel@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/02/2013 09:37 AM, ZX wrote:
>=20
>=20
> On Wed, 1 May 2013, Stephen Rothwell wrote:
>=20
>> Hi all,
>>
>> Please do not add any v3.11 destined work to your linux-next include=
d
>> branches until after v3.10-rc1 is released.
>>
>> Changes since 20130430:
>>
>> The nfsd tree lost its build failure.
>>
>> The xfs tree lost its build failure.
>>
>> The vfs tree gained conflicts against Linus' and the powerpc trees a=
nd
>> gained a build failure for which I applied a merge fix patch.
>>
>> The drm-intel tree gained a conflict against the drm tree.
>>
>> The block tree gained a conflict against Linus' tree.
>>
>> The arm-soc tree gained a conflict against the arm tree.
>>
>> The akpm tree lost a lot of patches that turned up elsewhere.
>>
>> --------------------------------------------------------------------=
--------
>=20
> randconf build failure:
>=20
> make -C drivers/scsi/aic7xxx/aicasm
> *** Install db development libraries
> gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c=20
> aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
> aicasm_symbol.c:48:19: fatal error: aicdb.h: No such file or director=
y
> compilation terminated.
>=20
>=20
> random config file attached.
>=20
>=20
You need to install berkeley db ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
