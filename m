From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/20] qla2xxx: Added interface to send ELS commands from
 driver.
Date: Tue, 8 Dec 2015 16:54:53 +0100
Message-ID: <5666FD4D.9000206@suse.de>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-6-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1449535747-2850-6-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c   |   36 +++++++
>  drivers/scsi/qla2xxx/qla_dbg.c    |    5 +-
>  drivers/scsi/qla2xxx/qla_def.h    |   19 ++++-
>  drivers/scsi/qla2xxx/qla_gbl.h    |    2 +
>  drivers/scsi/qla2xxx/qla_inline.h |    2 +
>  drivers/scsi/qla2xxx/qla_iocb.c   |  189 +++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/qla2xxx/qla_isr.c    |    6 +
>  7 files changed, 255 insertions(+), 4 deletions(-)
>=20
Well, this isn't actually an interface to send generic ELS commands,
it's an interface to send an explicit LOGO using ELS.
Personally, I'd prefer to have a 'real' ELS interface using bsg,
and map the explicit LOGO based on that.

Alternatively please fixup the description.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
