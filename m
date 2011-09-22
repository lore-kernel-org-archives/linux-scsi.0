From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 10:19:34 -0700 (PDT)
Message-ID: <1316711974.76038.YahooMailNeo@web31811.mail.mud.yahoo.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com> <FC1F9E38C0703341A1A750524E2525A9018AE2EB@XYUS-EX22.xyus.xyratex.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:47294 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751621Ab1IVRTf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 13:19:35 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2EB@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

LOOK AT THE SOURCE CODE: drivers/scsi/libsas/sas_expander.c:

/* Here we spill over 80 columns.=A0 It is intentional.
=A0*/
static int sas_check_parent_topology(struct domain_device *child)
{
=A0=A0=A0 struct expander_device *child_ex =3D &child->ex_dev;
=A0=A0=A0 struct expander_device *parent_ex;
=A0=A0=A0 int i;
=A0=A0=A0 int res =3D 0;

=A0=A0=A0 if (!child->parent)
=A0=A0=A0 =A0=A0=A0 return 0;

=A0=A0=A0 if (child->parent->dev_type !=3D EDGE_DEV &&
=A0=A0=A0 =A0=A0=A0 child->parent->dev_type !=3D FANOUT_DEV)
=A0=A0=A0 =A0=A0=A0 return 0;
=2E..

ARE WE DONE?

----- Original Message -----

> From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
> To: Luben Tuikov <ltuikov@yahoo.com>; James Bottomley <jbottomley@par=
allels.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Sent: Thursday, September 22, 2011 9:55 AM
> Subject: RE: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attac=
hments
>=20
> Except for the fact the patch as located in the attachment is still n=
ot in=20
> compliance, the patch works for me.
>=20
> Sincerely -- Mark Salyzyn
>=20
>>  scsi-misc-2.6/scripts/checkpatch.pl=20
> 0001-SCSI-libsas-Allow-expander-T-T-attachments.patch
> WARNING: line over 80 characters
> #57: FILE: drivers/scsi/libsas/sas_expander.c:1245:
> +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  if (chi=
ld_phy->routing_attr =3D=3D=20
> SUBTRACTIVE_ROUTING ||
>=20
> WARNING: line over 80 characters
> #59: FILE: drivers/scsi/libsas/sas_expander.c:1247:
> +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 child_ex->t2t_supp &&=20
> parent_ex->t2t_supp)) {
>=20
> WARNING: line over 80 characters
> #62: FILE: drivers/scsi/libsas/sas_expander.c:1250:
> +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0  sas_print_parent_topology_bug(child,=20
> parent_phy, child_phy);
>=20
> total: 0 errors, 3 warnings, 82 lines checked
>=20
> 0001-SCSI-libsas-Allow-expander-T-T-attachments.patch has style probl=
ems, please
> review.
>=20
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
>=20
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org]=20
> On Behalf Of Luben Tuikov
> Sent: Thursday, September 22, 2011 12:42 PM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachmen=
ts
>=20
> Allow expander table-to-table attachments for
> expanders that support it.
>=20
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
> =A0drivers/scsi/libsas/sas_expander.c |=A0=A0 20 ++++++++++++++------
> =A0include/scsi/libsas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=
=A0 3 +++
> =A0include/scsi/sas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 |=A0=A0 14 ++++++++++++--
> =A03 files changed, 29 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_expander.c=20
> b/drivers/scsi/libsas/sas_expander.c
> index f84084b..e8d0115 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -329,6 +329,7 @@ static void ex_assign_report_general(struct domai=
n_device=20
> *dev,
> =A0=A0=A0=A0 dev->ex_dev.ex_change_count =3D be16_to_cpu(rg->change_c=
ount);
> =A0=A0=A0=A0 dev->ex_dev.max_route_indexes =3D be16_to_cpu(rg->route_=
indexes);
> =A0=A0=A0=A0 dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPAN=
DER_PHYS);
> +=A0=A0=A0 dev->ex_dev.t2t_supp =3D rg->t2t_supp;
> =A0=A0=A0=A0 dev->ex_dev.conf_route_table =3D rg->conf_route_table;
> =A0=A0=A0=A0 dev->ex_dev.configuring =3D rg->configuring;
> =A0=A0=A0=A0 memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_l=
ogical_id,=20
> 8);
> @@ -1133,15 +1134,17 @@ static void sas_print_parent_topology_bug(str=
uct=20
> domain_device *child,
> =A0=A0=A0=A0 };
> =A0=A0=A0=A0 struct domain_device *parent =3D child->parent;
> =A0
> -=A0=A0=A0 sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx phy =
0x%x=20
> "
> -=A0=A0=A0 =A0=A0=A0 =A0=A0 "has %c:%c routing link!\n",
> +=A0=A0=A0 sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s e=
x=20
> %016llx "
> +=A0=A0=A0 =A0=A0=A0 =A0=A0 "(T2T supp:%d) phy 0x%x has %c:%c routing=
 link!\n",
> =A0
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[parent->dev_type],
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(parent->sas_addr),
> +=A0=A0=A0 =A0=A0=A0 =A0=A0 parent->ex_dev.t2t_supp,
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 parent_phy->phy_id,
> =A0
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[child->dev_type],
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(child->sas_addr),
> +=A0=A0=A0 =A0=A0=A0 =A0=A0 child->ex_dev.t2t_supp,
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->phy_id,
> =A0
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ra_char[parent_phy->routing_attr],
> @@ -1238,10 +1241,15 @@ static int sas_check_parent_topology(struct=20
> domain_device *child)
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent=
_topology_bug(child, parent_phy,=20
> child_phy);
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=
=3D TABLE_ROUTING &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->routing_at=
tr !=3D SUBTRACTIVE_ROUTING) {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_topology_bu=
g(child, parent_phy, child_phy);
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=
=3D TABLE_ROUTING) {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (child_phy->routing_attr =
=3D=3D SUBTRACTIVE_ROUTING ||
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 (child_phy->routin=
g_attr =3D=3D TABLE_ROUTING &&
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0 child_ex->t2t_s=
upp && parent_ex->t2t_supp))=20
> {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* All good */;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_t=
opology_bug(child, parent_phy,=20
> child_phy);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
> =A0=A0=A0=A0 =A0=A0=A0 case FANOUT_DEV:
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ee86606..793f80b 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -142,8 +142,11 @@ struct expander_device {
> =A0=A0=A0=A0 u16=A0=A0=A0 ex_change_count;
> =A0=A0=A0=A0 u16=A0=A0=A0 max_route_indexes;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 num_phys;
> +
> +=A0=A0=A0 u8=A0=A0=A0=A0 t2t_supp:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 configuring:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 conf_route_table:1;
> +
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 enclosure_logical_id[8];
> =A0
> =A0=A0=A0=A0 struct ex_phy *ex_phy;
> diff --git a/include/scsi/sas.h b/include/scsi/sas.h
> index e9fd022..f59f182 100644
> --- a/include/scsi/sas.h
> +++ b/include/scsi/sas.h
> @@ -341,7 +341,12 @@ struct report_general_resp {
> =A0
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 conf_route_table:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;
> -=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;
> +=A0=A0=A0 u8=A0=A0=A0 config_others:1;
> +=A0=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;
> +=A0=A0=A0 u8=A0=A0=A0 stp_cont_awt:1;
> +=A0=A0=A0 u8=A0=A0=A0 self_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 zone_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 t2t_supp:1;
> =A0
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_c;
> =A0
> @@ -528,7 +533,12 @@ struct report_general_resp {
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_a;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 num_phys;
> =A0
> -=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;
> +=A0=A0=A0 u8=A0=A0=A0 t2t_supp:1;
> +=A0=A0=A0 u8=A0=A0=A0 zone_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 self_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 stp_cont_awt:1;
> +=A0=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;
> +=A0=A0=A0 u8=A0=A0=A0 config_others:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 conf_route_table:1;
> =A0
> --=20
> 1.7.2.2.165.gbc382
> _____________________________________________________________________=
_
> This email may contain privileged or confidential information, which =
should only=20
> be used for the purpose for which it was sent by Xyratex. No further =
rights or=20
> licenses are granted to use such information. If you are not the inte=
nded=20
> recipient of this message, please notify the sender by return and del=
ete it. You=20
> may not use, copy, disclose or rely on the information contained in i=
t.
>=20
> Internet email is susceptible to data corruption, interception and un=
authorised=20
> amendment for which Xyratex does not accept liability. While we have =
taken=20
> reasonable precautions to ensure that this email is free of viruses, =
Xyratex=20
> does not accept liability for the presence of any computer viruses in=
 this=20
> email, nor for any losses caused as a result of viruses.
>=20
> Xyratex Technology Limited (03134912), Registered in England & Wales,=
=20
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>=20
> The Xyratex group of companies also includes, Xyratex Ltd, registered=
 in=20
> Bermuda, Xyratex International Inc, registered in California, Xyratex=
 (Malaysia)=20
> Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd regi=
stered in=20
> The People's Republic of China and Xyratex Japan Limited registered i=
n=20
> Japan.
> _____________________________________________________________________=
_
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
