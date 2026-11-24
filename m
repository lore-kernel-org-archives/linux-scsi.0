Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795495927;
	b=KzYBn1Zg9VvfQebAsGmuGwlv/+/ptd1s8Fal41sBJP401MWHlAuKE3VHUGMfTuliDntp
	 +NtzCw5Q7wNDu49+pTQAIbNjIi+bp2oyldIEkDA21+Pf5bQRlYmKmn6DYGiy43Fazy/5S
	 NWRhvX0iD3iFGV9mLUAjJwGz+uPhLIglhbF5rhGyoON72Ts4yElbLyy+Ct3OyjUmyVm0p
	 IoyNqIZG5S5lNz9ApwPaw9Ucx3af2l7XFTMRx3jOh5/4Hr1xkX84usMTdl1M4PIUL8SMe
	 BIEa2VcanJWJT13b08+HOSj+TXx1Toh0LkQU12Fp08/g4QVjbKdAryAVC+vkpU7X7Aw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795495927;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mo6GvUqe75iIaPADyrLuwp7xPDdb7gVXutzu95NbRUY=;
	b=sQW7ZWPDd8GPTrHfIWI7etx6jE5t/oXEme5I+7/SRziKt0VH9F0oRfdoeZPs6mH8E9Ll
	 TJh90sTSTYOeoBiLDJJl7qYHYvBMjku/dWe12zJE47ir99SR5h82v6SSL3HJmXKXcJmhm
	 dSlAYp8WXKVgtpdhp1yvn1mZPDPn9yW5nNOHl2iTYMsAvsq7eDYVMfuo2qWEKNKal94t8
	 TZQ7bIUtarlhhnnxDCAA5h08VKovN8b0lYA6Ne3zfUSZ0muasbLxGyaM6fwDBQTvHIB6q
	 30Y2ZvLSU+K5uecNWGSWlGW5MWEKLaI4LghSmCzFS2mAu258StL9DzMwvreO6Ev+Ahw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5zkwpyM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB80606A31E;
	Tue, 24 Nov 2026 04:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5zkwpyM
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795495926;
	b=NTpxALwEhUSB7jN6OKfmYhnKQ0Nok+1gAiHZECd2MTxcaeSTFGpTRHeuudQOFMPVVnBu
	 vLsscDb4Yer8/e6c0nVYnqwq98a4nm00OVXYQ5A3XPiuetItKKPNAlOBia5AQDGj2li93
	 oVgIx8tgzIwWkDz5uD/VGv0AnWmgpvzgyvC9wG4es909qF/vJ/Hjy/1stkIPXrBepB5EB
	 EMakSvjQHWo+gQ3rkMIW+6WTU7geUnBTLUmBYVv56tuSM2FsmzUokDspNo2lPrvA9Bhkd
	 rIDHk1VsQZnyE2XdgOFB+n0roqeCEtZHErKJ2cdZEaYzFmXKUoFyBfEAfOw7Ed7VHKw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795495926;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mo6GvUqe75iIaPADyrLuwp7xPDdb7gVXutzu95NbRUY=;
	b=jAMCNdk/3zh41VSon09th6rA16WuFcIOAkdixtGBORimew7wg2Ikx6yUaAyMANLeih6E
	 9POJydypntpTO5i2yuETNs1+v7xgThgmWqyKSki6X6OOQ+sUXo6K8QGVttHDCruSTArDj
	 AkPlJfGmiIKZ3sCVw+AOOWEyDuZZCQZCspOec87qxKlarfTsCEKGc3BHvlvspAYsqPvuW
	 2arkNpOOtgxQ/FqwOJtDErFNjZrZMT2XtbhpZkjbc3wttA41EOpw3Y6L7+k5X1QcFC9vj
	 qLob84pjtoqs0kTzhT8F8ijzDmdJNcPNZnbfVoBDlFwRauhE9miqyyhfLvI4T3Sf6qQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A05BD1F000C6;
	Tue, 24 Nov 2026 04:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795495926;
	bh=mo6GvUqe75iIaPADyrLuwp7xPDdb7gVXutzu95NbRUY=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=M5zkwpyMrRGeUcFDZzFpfGUwTDSLC7gkh2EBXrrH8kqYtqriFGIesPw7ZTcF7YCiF
	 2AHek7rD1V8Ido+gnqJt0p+upY6Vymd3oSyVJrnoYGUWLN8R6mfu2dm0JAkWp4/p5E
	 t16W2DhavoSh5HVuRfWAZZAIHF2pjAn+pwOaDaXtxuwztebJtZDog3TJGHoh+yytQo
	 UO9DJn28en0IlNhk5ZQZcEJ9VYoaor/4P8cRs5xNsj34l6mgFcZ6dAxbQAhN3yTebE
	 h1/YxBu6WPXU9KLReXkv5+1kyvc0fqEhdcw5+/UZuTl/NXkOwdez8iHCBF1NsQaJ1N
	 zxyaJkvnilIEg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C16AB4C899;
	Tue, 24 Nov 2026 04:52:01 +0000 (UTC)
From: Nayeon Kim via B4 Relay <devnull+nayeoni.kim.samsung.com@kernel.org>
Date: Tue, 24 Nov 2026 13:52:01 +0900
Subject: [PATCH] scsi: ufs: rpmb: Return -EIO instead of SCSI result on
 failure
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-b4-ufs-3-rpmb-errno-v1-1-65b54643ca21@samsung.com>
X-B4-Tracking: v=1; b=H4sIAPAXBWsC/yWMQQ6CMBBFr0K6dsTWRqpXMS7aMoUxsZAZMSaEu
 9vK8v3891YlyISibs2qGD8kNOUC+tCoOPo8IFBfWJmTuWhtLAQLSxI4A8+vAMicJ7jaPgXnMDn
 dqWLOjIm+/+r9sbMs4YnxXVP1EbwgBPY5jnWamAbKbXe0rUQh2O1t+wGLT3W0nwAAAA==
X-Change-ID: 20261124-b4-ufs-3-rpmb-errno-94dfb88ef817
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
 Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Bean Huo <beanhuo@micron.com>, Bart Van Assche <bvanassche@acm.org>, 
 linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795495921; l=2758;
 i=nayeoni.kim@samsung.com; s=20261102; h=from:subject:message-id;
 bh=bdGL8kCpC3JX6CQ4ZXGjUu6KFEVgq+FRVLoMwfb+mxQ=;
 b=wnlsK2i51g07bFO0PCnWWMLUSjpX0nWdj7ZXkYNQkbY4oNEvhgkEPccbKvPY35vmSpw3leWS/
 ZAr1jOewRBEBh7IU0o+hbOuN8qWaXYyH9Uv/WwDD3koZBzkQ/za6NgP
X-Developer-Key: i=nayeoni.kim@samsung.com; a=ed25519;
 pk=6rdU/EioX/vzm132vDyAq+TUk6SqpWqob+mz30+/n5E=
X-Endpoint-Received: by B4 Relay for nayeoni.kim@samsung.com/20261102 with
 auth_id=1381
X-Original-From: Nayeon Kim <nayeoni.kim@samsung.com>
Reply-To: nayeoni.kim@samsung.com
Content-Transfer-Encoding: 7bit

From: Nayeon Kim <nayeoni.kim@samsung.com>

rpmb_route_frames() is documented to return a negative errno on
failure, but ufs_sec_submit() returns the value of scsi_execute_cmd()
as is. When a SECURITY PROTOCOL IN/OUT command fails, that value is a
positive SCSI result such as SAM_STAT_CHECK_CONDITION or
DID_ERROR << 16. ufs_rpmb_route_frames() passes it up and logs it as
"ret=%d". Since scsi_execute_cmd() sets RQF_QUIET, the sense data is
not logged anywhere.

handle_rpc_func_rpmb_frames(), the only caller of rpmb_route_frames(),
checks for a non-zero return, so OP-TEE still sees the failure.

Log the SCSI result and sense data in ufs_sec_submit() and convert
positive results to -EIO, as ufshcd_set_dev_pwr_mode() does.

Signed-off-by: Nayeon Kim <nayeoni.kim@samsung.com>
---
Based on 7.4/scsi-fixes because it depends on commit 7bc9b854cd68
("scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF").
Not urgent; fine for 7.5. Compile-tested (W=1) only.
---
 drivers/ufs/core/ufs-rpmb.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 6803f3e62d78..d94633700cdf 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -19,6 +19,7 @@
 #include <linux/rpmb.h>
 #include <linux/string.h>
 #include <linux/list.h>
+#include <scsi/scsi_dbg.h>
 #include <ufs/ufshcd.h>
 #include <linux/unaligned.h>
 #include "ufshcd-priv.h"
@@ -55,10 +56,13 @@ static int ufs_sec_submit(struct ufs_rpmb_dev *ufs_rpmb, u16 spsp,
 	struct scsi_failures failures = {
 		.failure_definitions = failure_defs,
 	};
+	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
 		.failures = &failures,
 	};
 	u8 cdb[12] = { };
+	int ret;
 
 	if (!sdev || !scsi_device_online(sdev))
 		return -ENODEV;
@@ -68,9 +72,19 @@ static int ufs_sec_submit(struct ufs_rpmb_dev *ufs_rpmb, u16 spsp,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	return scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-				buffer, len, /*timeout=*/30 * HZ, /*retries=*/0,
-				&exec_args);
+	ret = scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+			       buffer, len, /*timeout=*/30 * HZ, /*retries=*/0,
+			       &exec_args);
+	if (ret > 0) {
+		dev_err(&ufs_rpmb->dev,
+			"SECURITY PROTOCOL %s failed: result %#x\n",
+			send ? "OUT" : "IN", ret);
+		if (scsi_sense_valid(&sshdr))
+			scsi_print_sense_hdr(sdev, NULL, &sshdr);
+		ret = -EIO;
+	}
+
+	return ret;
 }
 
 /* UFS RPMB route frames implementation */

---
base-commit: efd68f17acca65f581b9f2fa9ba50c8643ab544d
change-id: 20261124-b4-ufs-3-rpmb-errno-94dfb88ef817


