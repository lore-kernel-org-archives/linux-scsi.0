From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH 018/103] target: Remove struct se_global
Date: Sat, 23 Jul 2011 10:40:34 +0200
Message-ID: <CAJAFBLD9g_wfc4RizhbergOcMtYFfiwQ=s=iogK8geCajj7LgA@mail.gmail.com>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
	<1311231979-6631-19-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52366 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1GWIkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 04:40:35 -0400
In-Reply-To: <1311231979-6631-19-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Thu, Jul 21, 2011 at 9:04 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Andy Grover <agrover@redhat.com>
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target=
_core_tpg.c
> index dc024c1..4e2bee9 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -44,6 +44,12 @@
> =A0#include <target/target_core_fabric_ops.h>
>
> =A0#include "target_core_hba.h"
> +#include "target_core_stat.h"
> +
> +extern struct se_device *g_lun0_dev;

Same here: another extern declaraion in a C file.

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
