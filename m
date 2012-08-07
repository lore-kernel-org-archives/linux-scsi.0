From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/5] qla4xxx: Fix gcc warning for x86 system
Date: Tue,  7 Aug 2012 07:57:14 -0400
Message-ID: <1344340637-25526-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:42777 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754507Ab2HGMPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2012 08:15:14 -0400
In-Reply-To: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

=46rom: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

=46ix warning:-
drivers/scsi/qla4xxx/ql4_nx.c:1867:2: warning: format =E2=80=98%lx=E2=80=
=99 expects argument of type =E2=80=98long unsigned int=E2=80=99, but a=
rgument 5 has type =E2=80=98uint32_t=E2=80=99 [-Wformat]

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_n=
x.c
index 939d726..f2e961d 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1865,7 +1865,7 @@ static void qla4_8xxx_minidump_process_rdocm(stru=
ct scsi_qla_host *ha,
 		r_addr +=3D r_stride;
 	}
 	DEBUG2(ql4_printk(KERN_INFO, ha, "Leaving fn: %s datacount: 0x%lx\n",
-			  __func__, (loop_cnt * sizeof(uint32_t))));
+		__func__, (long unsigned int) (loop_cnt * sizeof(uint32_t))));
 	*d_ptr =3D data_ptr;
 }
=20
--=20
1.7.8.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
