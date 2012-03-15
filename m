From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/6] qla2xxx: remove obvious warnings
Date: Thu, 15 Mar 2012 14:37:23 -0700
Message-ID: <1331847443.10203.63.camel@haakon2.linux-iscsi.org>
References: <20120315190512.GB7685@logfs.org>
	 <20120315190639.GD7685@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120315190639.GD7685@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, target-devel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-03-15 at 15:06 -0400, J=C3=B6rn Engel wrote:
> Get rid of a bunch of write-only variables.  In a number of cases I
> suspect actual bugs to be present, so I left all of those for a secon=
d
> look.
>=20
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c   |    2 --
>  drivers/scsi/qla2xxx/qla_bsg.c    |    2 --
>  drivers/scsi/qla2xxx/qla_dbg.c    |    9 ---------
>  drivers/scsi/qla2xxx/qla_init.c   |    2 --
>  drivers/scsi/qla2xxx/qla_iocb.c   |   17 ++---------------
>  drivers/scsi/qla2xxx/qla_isr.c    |    2 --
>  drivers/scsi/qla2xxx/qla_mbx.c    |    4 ----
>  drivers/scsi/qla2xxx/qla_mid.c    |    3 +--
>  drivers/scsi/qla2xxx/qla_nx.c     |    9 +++------
>  drivers/scsi/qla2xxx/qla_os.c     |    8 +-------
>  drivers/scsi/qla2xxx/qla_target.c |    8 ++------
>  11 files changed, 9 insertions(+), 57 deletions(-)
>=20

This patch does not apply against lio-core HEAD, and since some of this
code is not directly target related, those pieces should be going
through the scsi tree.

--nab
