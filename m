From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] scsi_dh: Adding LSI vendor and product ids in
 rdac device list
Date: Mon, 10 Nov 2008 16:17:48 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BE75982@cosmail01.lsi.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "andmike@linux.vnet.ibm.com" <andmike@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Babu Moger <babu.moger@lsi.com>

This patch adds LSI vendor and product ids in rdac device handler.

Signed-off-by: Babu Moger <Babu.Moger@lsi.com>

---

--- linux-2.6.28-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c.orig    2=
008-11-10 16:56:01.000000000 -0600
+++ linux-2.6.28-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c 2008-11-1=
0 16:56:20.000000000 -0600
@@ -594,6 +594,8 @@ static const struct scsi_dh_devlist rdac
        {"SUN", "LCSM100_F"},
        {"DELL", "MD3000"},
        {"DELL", "MD3000i"},
+       {"LSI", "INF-01-00"},
+       {"ENGENIO", "INF-01-00"},
        {NULL, NULL},
 };
