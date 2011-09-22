From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 10:48:36 -0700
Message-ID: <CAA9_cmdrwf-xKa2cV1ZzSDiqkjEPdQQdQr9sY6Zn7kvUMbh9qw@mail.gmail.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1316691000.10571.6.camel@dabdike>
	<1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE2EB@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60607 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1IVRsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2011 13:48:37 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2EB@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 9:55 AM, Mark Salyzyn
<mark_salyzyn@us.xyratex.com> wrote:
> Except for the fact the patch as located in the attachment is still n=
ot in compliance, the patch works for me.
>
> Sincerely -- Mark Salyzyn
>
>> scsi-misc-2.6/scripts/checkpatch.pl 0001-SCSI-libsas-Allow-expander-=
T-T-attachments.patch
> WARNING: line over 80 characters
> #57: FILE: drivers/scsi/libsas/sas_expander.c:1245:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (chi=
ld_phy->routing_attr =3D=3D SUBTRACTIVE_ROUTING ||
>
> WARNING: line over 80 characters
> #59: FILE: drivers/scsi/libsas/sas_expander.c:1247:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0child_ex->t2t_supp && parent_ex->t2t_supp)) {
>
> WARNING: line over 80 characters
> #62: FILE: drivers/scsi/libsas/sas_expander.c:1250:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sas_print_parent_topology_bug(child, parent_phy, child_phy);
>
> total: 0 errors, 3 warnings, 82 lines checked
>

Minor infractions of 80 columns are acceptable when they improve readab=
ility.

checkpactch clean to me is no errors.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
