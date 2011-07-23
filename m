From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH 018/103] target: Remove struct se_global
Date: Sat, 23 Jul 2011 10:38:30 +0200
Message-ID: <CAJAFBLAjmDs0HvUR2oZ2tk+DDw=5LcQLbE_k0jAxfcQbjAZU4A@mail.gmail.com>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
	<1311231979-6631-19-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58788 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1GWIib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 04:38:31 -0400
In-Reply-To: <1311231979-6631-19-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Thu, Jul 21, 2011 at 9:04 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/t=
arget_core_configfs.c
> index 03cda0e..82c8e9a 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -37,6 +37,7 @@
> =A0#include <linux/parser.h>
> =A0#include <linux/syscalls.h>
> =A0#include <linux/configfs.h>
> +#include <linux/spinlock.h>
>
> =A0#include <target/target_core_base.h>
> =A0#include <target/target_core_device.h>
> @@ -52,6 +53,8 @@
> =A0#include "target_core_rd.h"
> =A0#include "target_core_stat.h"
>
> +extern struct t10_alua_lu_gp *default_lu_gp;

I see here an extern declaration in a .c file. Shouldn't instead that
be moved to a header file ?

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
