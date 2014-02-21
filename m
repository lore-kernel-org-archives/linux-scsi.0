From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.3 1/11] arcmsr: Revise interrupt service routine to
 fix command timeout
Date: Fri, 21 Feb 2014 10:20:01 +0300
Message-ID: <20140221072001.GF26776@mwanda>
References: <CAKiknE9M44XvZQSjGRSgvgUHrgfbhwj8eTNRHWJ-VO+NU=cbvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKiknE9M44XvZQSjGRSgvgUHrgfbhwj8eTNRHWJ-VO+NU=cbvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2014 at 10:56:34AM +0800, =E9=BB=83=E6=B8=85=E9=9A=86 w=
rote:
> From: Ching <ching2048@areca.com.tw>
>=20
> Rewrite interrupt service routine to fix command timeout on controlle=
r
> too heavy loading.
>=20
> Singed-off-by: Ching <ching2048@areca.com.tw>

This email is still line wrapped I'm afraid.  It doesn't apply.

> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c
> b/drivers/scsi/arcmsr/arcmsr_attr.c
> --- a/drivers/scsi/arcmsr/arcmsr_attr.c 2014-02-07 01:47:24.000000000=
 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_attr.c 2014-01-10 20:28:48.000000000=
 +0800
> -#define ARCMSR_SCSI_INITIATOR_ID
>          255
> +#define ARCMSR_SCSI_INITIATOR_ID       255

Please do white space changes in a separate change set so that the logi=
c
changes are easier to review.

Use "git citool".  Highlight the lines with white space changes and the=
n
right click and select "Stage lines for commit".  It is a very useful
tool.

regards,
dan carpenter
