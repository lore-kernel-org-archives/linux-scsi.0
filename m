From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] SCSI: libfc: remove define of fc_seq_exch in
	fc_exch.c
Date: Thu, 7 Oct 2010 09:39:15 +0800
Message-ID: <AANLkTi=GRy0-TCQT1Hr8qy2LaRPWnN3qk=QxMk7GoC12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "James E.J. Bottomley" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

The define for fc_seq_exch is unnecessary, since it also appears in scsi/libfc.h

Signed-off-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

--- o/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-10-07
09:33:12.000000000 +0800
@@ -108,7 +108,6 @@ struct fc_exch_mgr {
 		atomic_t non_bls_resp;
 	} stats;
 };
-#define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)

 /**
  * struct fc_exch_mgr_anchor - primary structure for list of EMs
