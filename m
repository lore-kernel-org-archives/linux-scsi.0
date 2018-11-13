From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Tue, 13 Nov 2018 21:52:46 +0530
Message-ID: <CAJr6mf299-x5RmX3Lm=pVwWoP_374sMi8sw3x=h8TgG0t0d0SA@mail.gmail.com>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com> <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
 <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de> <1542125473.3042.6.camel@linux.vnet.ibm.com>
 <c58db296-87ec-5aaf-f6ce-1115d5d2a2c1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c58db296-87ec-5aaf-f6ce-1115d5d2a2c1@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jthumshirn@suse.de
Cc: jejb@linux.vnet.ibm.com, john.garry@huawei.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, martin.petersen@oracle.com, Souptick Joarder <jrdr.linux@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 13, 2018 at 9:46 PM Johannes Thumshirn <jthumshirn@suse.de> wro=
te:
>
> On 13/11/2018 17:11, James Bottomley wrote:
> > This is incorrect advice: there's no need to cast it to other *pointer*
> > types, but if you cast it to a non-pointer type (which this is doing)
> > the compiler will complain if there is no explicit cast.
shall I leave the typecast as it is?
> Right, sorry for that and thanks for spotting it James.
>
> Byte,
>         Johannes
> --
> Johannes Thumshirn                                        SUSE Labs
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
