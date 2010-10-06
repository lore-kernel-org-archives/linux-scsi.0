From: "Jack Wang" <jack_wang@usish.com>
Subject: [PATCH] libsas: do not return error for table2table link
Date: Wed, 6 Oct 2010 17:13:44 +0800
Message-ID: <646EF126DF5645B48AF69E3E459A1CB7@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0009_01CB6579.D5005C90"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:60236 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0JFJKR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 05:10:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, 'James Bottomley' <jejb@kernel.org>
Cc: 'tom_peng' <tom_peng@usish.com>, 'lindar_liu' <lindar_liu@usish.com>, 'roy' <roy_wang@usish.com>, linux-scsi@vger.kernel.org, "'Darrick J. Wong'" <djwong@us.ibm.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0009_01CB6579.D5005C90
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, all

In SAS2 spec table to table link is allowed and useful in self-configurable
topology, so we should not return error for this.

Jack

From: Jack Wang <jack_wang@usish.com>
Date: Wed, 6 Oct 2010 16:59:29 +0800
Subject: [PATCH] Do not return error when encounters table2table link

Signed-off-by: Tom Peng <tom_peng@usish.com>
Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
---
 sas_expander.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sas_expander.c b/sas_expander.c
index f282234..7be9422 100644
--- a/sas_expander.c
+++ b/sas_expander.c
@@ -1233,7 +1233,6 @@ static int sas_check_parent_topology(struct
domain_device *child)
 			} else if (parent_phy->routing_attr == TABLE_ROUTING
&&
 				   child_phy->routing_attr !=
SUBTRACTIVE_ROUTING) {
 				sas_print_parent_topology_bug(child,
parent_phy, child_phy);
-				res = -ENODEV;
 			}
 			break;
 		case FANOUT_DEV:
-- 
1.7.2.3.msysgit.0


------=_NextPart_000_0009_01CB6579.D5005C90
Content-Type: application/octet-stream;
	name="0001-Do-not-return-error-when-enconter-table2table-link.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Do-not-return-error-when-enconter-table2table-link.patch"

>From 6daaaabc92e10983ff3d421103e678cc3abaf7e7 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 6 Oct 2010 16:59:29 +0800=0A=
Subject: [PATCH] Do not return error when enconter table2table link=0A=
=0A=
Signed-off-by: Tom Peng <tom_peng@usish.com>=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
---=0A=
 sas_expander.c |    1 -=0A=
 1 files changed, 0 insertions(+), 1 deletions(-)=0A=
=0A=
diff --git a/sas_expander.c b/sas_expander.c=0A=
index f282234..7be9422 100644=0A=
--- a/sas_expander.c=0A=
+++ b/sas_expander.c=0A=
@@ -1233,7 +1233,6 @@ static int sas_check_parent_topology(struct =
domain_device *child)=0A=
 			} else if (parent_phy->routing_attr =3D=3D TABLE_ROUTING &&=0A=
 				   child_phy->routing_attr !=3D SUBTRACTIVE_ROUTING) {=0A=
 				sas_print_parent_topology_bug(child, parent_phy, child_phy);=0A=
-				res =3D -ENODEV;=0A=
 			}=0A=
 			break;=0A=
 		case FANOUT_DEV:=0A=
-- =0A=
1.7.2.3.msysgit.0=0A=
=0A=

------=_NextPart_000_0009_01CB6579.D5005C90--

