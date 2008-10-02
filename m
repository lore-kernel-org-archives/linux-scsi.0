From: <Yanqing_Liu@Dell.com>
Subject: [Patch] scsi_dh_rdac.c: add Dell product information
	into rdac device handler
Date: Thu, 2 Oct 2008 10:11:33 -0500
Message-ID: <00FE57DD11E3A94893D5BD54C3358BE884BF38@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Shyam_Iyer@Dell.com
List-Id: linux-scsi@vger.kernel.org


Hi all,

Re-send this patch in the proper format. Thanks for James's email about
this.
---

The following patch is to add Dell Powervault storage arrays into device
list of rdac device handler.


Signed-off-by: Yanqing Liu <yanqing_liu@dell.com>

--- linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
2008-09-29 02:31:26.000000000 -0400
+++ linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c
2008-09-30 02:06:26.000000000 -0400
@@ -590,6 +590,8 @@
{"STK", "OPENstorage D280"},
{"SUN", "CSM200_R"},
{"SUN", "LCSM100_F"},
+ {"DELL", "MD3000"},
+ {"DELL", "MD3000i"},
{NULL, NULL},
};
