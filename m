From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v3] qla2xxx: silence two GCC warnings
Date: Tue, 29 Jan 2013 10:57:06 +0100
Message-ID: <1359453426.1345.30.camel@x61.thuisdomein>
References: <CC98F9D4.ECE6%saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CC98F9D4.ECE6%saurav.kashyap@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-10-08 at 11:15 -0500, Saurav Kashyap wrote:
> Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>=20
> Thanks,
> ~Saurav
>=20
> >Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
> >warnings:
> >    drivers/scsi/qla2xxx/qla_gs.c: In function =C5=92qla2x00_fdmi_rh=
ba=C2=B9:
> >    drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript i=
s
> >above array bounds [-Warray-bounds]
> >    drivers/scsi/qla2xxx/qla_gs.c: In function =C5=92qla2x00_fdmi_re=
gister=C2=B9:
> >    drivers/scsi/qla2xxx/qla_gs.c:1663:15: warning: array subscript =
is
> >above array bounds [-Warray-bounds]

This patch was originally posted to silence two GCC warnings while
building v3.6-rc7. Basically identical warnings can still be seen while
building v3.8-rc5. What's the status of this patch?


Paul Bolle
