Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021421;
	b=Z7zziQDFpi9wedwpdUpf+ETaZXDFPaKcVRroPQCYDGyxd6wU/MzQwDyZmTACg9dRBY7e
	 xHyHIbBkAbz1srT5XfBg6GNb7qLQbURK7kiQio1Js4nED3izkCNBKnXcMMUA7RFem9AjD
	 RXUdKpfnb4L6UcGyOzUq2hwPNuPrGfYQhXvy80uCwQpLx1fVaymNsedl+lYRn69ED8znU
	 02eceGP/tceeCcNrwu+qaUj5HjGRL3oSkyKdy0XxTyTb6aKthdxm4INqPl/PTIKbuLwTB
	 ObYif4omuUubOoxGd8y0e+/kfP/Fyjnz41Xk8+uo1xuU/ZcMQDc/gmJBLMsvP47448A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021421;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:Autocrypt:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=3+Y3EvPyQI+2roxszPVLCrgLtLBgiMLOpqcqzhqtOzk=;
	b=ZbHXdZLyLDYNZ+fOIH6bUGDkxD8e75HfwqR5p3U9YBaYZeoZlahoD5hkhCVCzuhj7lBI
	 fZTe9J4bVcuLGBdWbQNHI8crU/4IbUOBaozeaLfHbF74/fxIIE7IzACpfNlyZrKuKQqbo
	 Asg1nuzH7KOynLLJIwEnDOBdYS+bczYZy3yM448eGPzueuZe4pjUlgtiqPHPoMQkOVRlG
	 n9Z+RB/pyX4cv9q6j5XwePYtaurUjSEXZhfLrbKqSKg1ZC5J/BdOv4jvi55EScLcvRaJ+
	 cWmlyLasXHmG0DQ70J6kDHNQ2rlfjug1be99FmUWG4hhOnNlkRjtgOr6GkyBfwsygnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=QgaeLfLw;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719CE606A331;
	Wed, 18 Nov 2026 17:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 719CE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=QgaeLfLw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1795021418;
	bh=+xAWFVPynLLKt7t6sP8HoOEQC/bQPvwl+OICs+ixn4s=;
	h=Message-ID:Subject:From:To:Date:From;
	b=QgaeLfLwj4zppaHir65uBPMkA70XxYYVbBfSUaoDN6d0nhqcTr2jUaPhqFwfQJgvv
	 Bc153qCcn5GQSQQbnr5RSvufxN47+BcmoVbiZWVSgvs952SBLSsD4FFSLm/6/v06In
	 P17VZisWPOEZRIHu8M3xecioAmZH6LnAVR1KezK4=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 411A51C0228;
	Wed, 18 Nov 2026 12:03:38 -0500 (EST)
Message-ID: <6a9f642705eb17beabdeb7388136e28729da6bfb.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.4-rc3+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 18 Nov 2026 12:03:37 -0500
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

The following changes since commit ca14cc05808f9c0115c38bec53573bf93e030435=
:

  Merge branch '7.4/scsi-queue' into 7.4/scsi-fixes (2026-11-02 21:06:42 -0=
500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to e550f2b2b4aab4c5f12db89d04d8978ce4ed7b4e:

  scsi: mpi3mr: Validate reply frame size bounds (2026-11-08 22:36:12 -0500=
)

----------------------------------------------------------------
Mostly driver fixes.  The only core one is the bsg one to prevent
copying of sense data after the task is cancelled (which could result in
random memory writes from the kernel).  ufs has the largest set of
fixes, but they're also fairly mundane.

I was supposed to be sending this on Saturday, but managed to spend the
weekend rushing around airports instead thanks to the FAA problem on
returning from KVM forum.

----------------------------------------------------------------
Boyan Liu (1):
      scsi: sd_zbc: Cap zone report count by buffer size

Ciro Iriarte (1):
      scsi: target: core: Parse APTPL res_type and res_scope as hex

Dmitry Bogdanov (2):
      scsi: Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING=
 commands"
      scsi: target: iscsi: Fix hanging WRITE_PENDING commands

Dongdong Hao (1):
      scsi: leapraid: Fix init_cmd_priv error handling

James Houghton (1):
      scsi: bsg: Don't copy sense data to user memory when canceled

Joonhoe Kim (1):
      scsi: ufs: qcom: Reprogram ESI after a host controller reset

Kiwoong Kim (2):
      scsi: ufs: core: Skip ABORT TASK for device management commands
      scsi: ufs: mcq: Poll OCS after sq cleanup for device management comma=
nds

Milan P. Gandhi (1):
      scsi: mpi3mr: Validate reply frame size bounds

Praneeth Balasubramanian (1):
      scsi: target: iscsi: Check for existing sessions only after authentic=
ation

Shao Mingyin (3):
      scsi: target: Fix NULL pointer dereference in target_dev_alua_lu_gp_s=
tore()
      scsi: target: Fix NULL pointer dereference in core_alua_do_port_trans=
ition()
      scsi: rdac: Keep the error status when controller lookup fails

Shawn Lin (1):
      scsi: ufs: rockchip: Improve RX noise immunity

Stanley Jhu (6):
      scsi: ufs: core: Keep clock-gating hold on failed W-LUN runtime resum=
e
      scsi: ufs: core: Restore jiffies conversion of device management time=
outs
      scsi: ufs: core: Introduce ufshcd_rpm_resume_and_get() helper
      scsi: ufs: sysfs: Propagate runtime PM resume errors
      scsi: ufs: bsg: Abort ufs_bsg_request() when runtime resume fails
      scsi: ufs: hwmon, debugfs: Propagate runtime PM resume errors

 drivers/scsi/device_handler/scsi_dh_rdac.c |  6 +--
 drivers/scsi/leapraid/leapraid_os.c        | 10 +----
 drivers/scsi/mpi3mr/mpi3mr.h               |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c            | 18 ++++++++
 drivers/scsi/scsi_bsg.c                    | 10 ++++-
 drivers/scsi/sd_zbc.c                      |  9 +++-
 drivers/target/iscsi/iscsi_target.c        | 19 ---------
 drivers/target/iscsi/iscsi_target_erl1.c   |  8 ----
 drivers/target/iscsi/iscsi_target_nego.c   |  6 +--
 drivers/target/target_core_alua.c          |  7 ++++
 drivers/target/target_core_configfs.c      | 16 +++++--
 drivers/ufs/core/ufs-debugfs.c             |  8 +++-
 drivers/ufs/core/ufs-hwmon.c               | 12 +++++-
 drivers/ufs/core/ufs-mcq.c                 | 34 +++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 67 +++++++++++++++++++++++---=
----
 drivers/ufs/core/ufs_bsg.c                 |  4 +-
 drivers/ufs/core/ufshcd-priv.h             |  5 +++
 drivers/ufs/core/ufshcd.c                  | 42 ++++++++++++-------
 drivers/ufs/host/ufs-qcom.c                | 12 ++++--
 drivers/ufs/host/ufs-qcom.h                |  2 +
 drivers/ufs/host/ufs-rockchip.c            |  1 +
 include/scsi/scsi_proto.h                  |  3 ++
 22 files changed, 217 insertions(+), 83 deletions(-)

With full diff below

Regards,

James

---

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/devi=
ce_handler/scsi_dh_rdac.c
index 742534c99386..0986a6e2a6ae 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -450,14 +450,14 @@ static int initialize_controller(struct scsi_device *=
sdev,
=20
 		spin_lock(&list_lock);
 		h->ctlr =3D get_controller(index, array_name, array_id, sdev);
-		if (!h->ctlr)
+		if (!h->ctlr) {
 			err =3D SCSI_DH_RES_TEMP_UNAVAIL;
-		else {
+		} else {
 			h->sdev =3D sdev;
 			list_add_rcu(&h->node, &h->ctlr->dh_list);
+			err =3D SCSI_DH_OK;
 		}
 		spin_unlock(&list_lock);
-		err =3D SCSI_DH_OK;
 	}
 	return err;
 }
diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/le=
apraid_os.c
index da597eb99377..749e50366dbc 100644
--- a/drivers/scsi/leapraid/leapraid_os.c
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -935,22 +935,16 @@ static int leapraid_init_cmd_priv(struct Scsi_Host *s=
host,
 				  struct scsi_cmnd *scmd)
 {
 	struct leapraid_adapter *adapter =3D shost_priv(shost);
-	struct leapraid_io_req_tracker *io_tracker;
=20
-	io_tracker =3D scsi_cmd_priv(scmd);
-	leapraid_internal_init_cmd_priv(adapter, io_tracker);
-
-	return 0;
+	return leapraid_internal_init_cmd_priv(adapter, scsi_cmd_priv(scmd));
 }
=20
 static int leapraid_exit_cmd_priv(struct Scsi_Host *shost,
 				  struct scsi_cmnd *scmd)
 {
 	struct leapraid_adapter *adapter =3D shost_priv(shost);
-	struct leapraid_io_req_tracker *io_tracker;
=20
-	io_tracker =3D scsi_cmd_priv(scmd);
-	leapraid_internal_exit_cmd_priv(adapter, io_tracker);
+	leapraid_internal_exit_cmd_priv(adapter, scsi_cmd_priv(scmd));
=20
 	return 0;
 }
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index d6e16707fd97..e78383df619c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -83,6 +83,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_ADMIN_REPLY_Q_SIZE	(8 * MPI3MR_PAGE_SIZE_4K)
 #define MPI3MR_ADMIN_REQ_FRAME_SZ	128
 #define MPI3MR_ADMIN_REPLY_FRAME_SZ	16
+#define MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS	16	/* 64 bytes */
=20
 /* Operational queue management definitions */
 #define MPI3MR_OP_REQ_Q_QD		512
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_f=
w.c
index f0d3cd398dd0..60a92366e590 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3261,6 +3261,7 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *m=
rioc,
 	struct mpi3_ioc_facts_data *facts_data)
 {
 	struct mpi3_ioc_facts_request iocfacts_req;
+	u16 reply_frame_size;
 	void *data =3D NULL;
 	dma_addr_t data_dma;
 	u32 data_len =3D sizeof(*facts_data);
@@ -3318,6 +3319,23 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *=
mrioc,
 		goto out_unlock;
 	}
 	memcpy(facts_data, (u8 *)data, data_len);
+
+	reply_frame_size =3D le16_to_cpu(facts_data->reply_frame_size);
+	/*
+	 * Validate reply_frame_size:
+	 * - Must be at least 16 dwords (64 bytes) to accommodate fixed reply
+	 *   structures and avoid underflow/divide-by-zero in logdata sizing.
+	 * - Must not exceed U16_MAX / 4 to prevent integer overflow.
+	 */
+	if (reply_frame_size < MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS ||
+	    reply_frame_size > (U16_MAX / 4)) {
+		ioc_err(mrioc, "Invalid reply_frame_size %u (must be %u..%u dwords)\n",
+			reply_frame_size, MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS,
+			(unsigned int)(U16_MAX / 4));
+		retval =3D -EINVAL;
+		goto out_unlock;
+	}
+
 	mpi3mr_process_factsdata(mrioc, facts_data);
 out_unlock:
 	mrioc->init_cmds.state =3D MPI3MR_CMD_NOTUSED;
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e4a65d7a2374..3cf1caad02f7 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -43,9 +43,17 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_r=
eq, io_tw_token_t tw)
 	if (pdu->bio)
 		ret =3D blk_rq_unmap_user(pdu->bio);
=20
+	/*
+	 * If the request is being canceled, e.g. because the submitting task
+	 * has exited, this may run from a kworker or in a different task, so
+	 * don't copy the sense data to the submitter's address.
+	 */
+	if (unlikely(tw.cancel))
+		ret =3D -ECANCELED;
+
 	if (scsi_status_is_check_condition(scmd->result)) {
 		driver_status =3D DRIVER_SENSE;
-		if (pdu->response_addr)
+		if (pdu->response_addr && !tw.cancel)
 			sense_len_wr =3D min_t(unsigned int, pdu->max_response_len,
 					     scmd->sense_len);
 	}
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 8cbf171e6fab..06f4e3fcda1d 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -222,7 +222,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t =
sector,
 {
 	struct scsi_disk *sdkp =3D scsi_disk(disk);
 	sector_t lba =3D sectors_to_logical(sdkp->device, sector);
-	unsigned int nr, i;
+	unsigned int nr, i, max_in_buf;
 	unsigned char *buf;
 	u64 zone_length, start_lba;
 	size_t offset, buflen =3D 0;
@@ -241,13 +241,18 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,
 	if (!buf)
 		return -ENOMEM;
=20
+	max_in_buf =3D (buflen - ZBC_REPORT_ZONES_HEADER_SIZE) /
+		ZBC_ZONE_DESCRIPTOR_SIZE;
+
 	while (zone_idx < nr_zones && lba < sdkp->capacity) {
 		ret =3D sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
 		if (ret)
 			goto out;
=20
 		offset =3D 0;
-		nr =3D min(nr_zones, get_unaligned_be32(&buf[0]) / 64);
+		nr =3D min3(nr_zones - zone_idx,
+			  get_unaligned_be32(&buf[0]) / ZBC_ZONE_DESCRIPTOR_SIZE,
+			  max_in_buf);
 		if (!nr)
 			break;
=20
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 124ff269b8e7..03d618cd7672 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1518,25 +1518,6 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn,=
 void *buf,
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
 				iscsit_stop_dataout_timer(cmd);
=20
-			return iscsit_dump_data_payload(conn, payload_length, 1);
-		}
-	} else {
-		/*
-		 * For the normal solicited data path:
-		 *
-		 * Check for a delayed TASK_ABORTED status and dump any
-		 * incoming data out payload if one exists.  Also, when the
-		 * ISCSI_FLAG_CMD_FINAL is set to denote the end of the current
-		 * data out sequence, we decrement outstanding_r2ts.  Once
-		 * outstanding_r2ts reaches zero, go ahead and send the delayed
-		 * TASK_ABORTED status.
-		 */
-		if (se_cmd->transport_state & CMD_T_ABORTED) {
-			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1) {
-				iscsit_stop_dataout_timer(cmd);
-				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
-			}
=20
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscs=
i/iscsi_target_erl1.c
index d8ca06e697d6..44b851e4a602 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -908,8 +908,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 				return 0;
 			}
 			spin_unlock_bh(&cmd->istate_lock);
-			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-				return 0;
 			return transport_send_check_condition_and_sense(se_cmd,
 					cmd->sense_reason, 0);
 		}
@@ -927,9 +925,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
=20
 			if (!(cmd->cmd_flags &
 					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-				if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-					return 0;
-
 				iscsit_set_dataout_sequence_values(cmd);
 				conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 			}
@@ -942,9 +937,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
=20
 		if ((cmd->data_direction =3D=3D DMA_TO_DEVICE) &&
 		    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-				return 0;
-
 			iscsit_set_unsolicited_dataout(cmd);
 		}
 		return target_submit(&cmd->se_cmd);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscs=
i/iscsi_target_nego.c
index b03ed154ca34..ccd468e26fb9 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -982,9 +982,6 @@ static int iscsi_target_handle_csg_one(struct iscsit_co=
nn *conn, struct iscsi_lo
 		if (iscsi_target_check_first_request(conn, login) < 0)
 			return -1;
=20
-	if (iscsi_target_check_for_existing_instances(conn, login) < 0)
-		return -1;
-
 	ret =3D iscsi_encode_text_output(
 			PHASE_OPERATIONAL|PHASE_DECLARATIVE,
 			SENDER_TARGET,
@@ -1008,6 +1005,9 @@ static int iscsi_target_handle_csg_one(struct iscsit_=
conn *conn, struct iscsi_lo
 		return -1;
 	}
=20
+	if (iscsi_target_check_for_existing_instances(conn, login) < 0)
+		return -1;
+
 	if (!iscsi_check_negotiated_keys(conn->param_list))
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE3) &&
 		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT))
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core=
_alua.c
index 140154d93c43..17386c96de13 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1081,8 +1081,15 @@ int core_alua_do_port_transition(
 		return -EINVAL;
=20
 	local_lu_gp_mem =3D l_dev->dev_alua_lu_gp_mem;
+	if (!local_lu_gp_mem)
+		return -ENODEV;
+
 	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
 	lu_gp =3D local_lu_gp_mem->lu_gp;
+	if (!lu_gp) {
+		spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
+		return -ENODEV;
+	}
 	atomic_inc(&lu_gp->lu_gp_ref_cnt);
 	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
 	/*
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_=
core_configfs.c
index 2b19a956007b..385b84bcbfb2 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2126,8 +2126,8 @@ static match_table_t tokens =3D {
 	{Opt_initiator_sid, "initiator_sid=3D%s"},
 	{Opt_sa_res_key, "sa_res_key=3D%s"},
 	{Opt_res_holder, "res_holder=3D%d"},
-	{Opt_res_type, "res_type=3D%d"},
-	{Opt_res_scope, "res_scope=3D%d"},
+	{Opt_res_type, "res_type=3D%x"},
+	{Opt_res_scope, "res_scope=3D%x"},
 	{Opt_res_all_tg_pt, "res_all_tg_pt=3D%d"},
 	{Opt_mapped_lun, "mapped_lun=3D%u"},
 	{Opt_target_fabric, "target_fabric=3D%s"},
@@ -2229,13 +2229,13 @@ static ssize_t target_pr_res_aptpl_metadata_store(s=
truct config_item *item,
 			res_holder =3D arg;
 			break;
 		case Opt_res_type:
-			ret =3D match_int(args, &arg);
+			ret =3D match_hex(args, &arg);
 			if (ret)
 				goto out;
 			type =3D (u8)arg;
 			break;
 		case Opt_res_scope:
-			ret =3D match_int(args, &arg);
+			ret =3D match_hex(args, &arg);
 			if (ret)
 				goto out;
 			break;
@@ -2547,6 +2547,14 @@ static ssize_t target_dev_alua_lu_gp_store(struct co=
nfig_item *item,
=20
 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 	lu_gp =3D lu_gp_mem->lu_gp;
+	if (!lu_gp && !lu_gp_new) {
+		/*
+		 * The LU group association has already been cleared, so
+		 * there is nothing left to do.
+		 */
+		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
+		return count;
+	}
 	if (lu_gp) {
 		/*
 		 * Clearing an existing lu_gp association, and replacing
diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.=
c
index 9f83628f3e2c..44a1a9692324 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -70,12 +70,18 @@ token_context_lock(ufs_debugfs);
 static int ufs_debugfs_get_user_access(struct ufs_hba *hba)
 	__cond_acquires(0, ufs_debugfs)
 {
+	int err;
+
 	down(&hba->host_sem);
 	if (!ufshcd_is_user_access_allowed(hba)) {
 		up(&hba->host_sem);
 		return -EBUSY;
 	}
-	ufshcd_rpm_get_sync(hba);
+	err =3D ufshcd_rpm_resume_and_get(hba);
+	if (err) {
+		up(&hba->host_sem);
+		return err;
+	}
 	__acquire(ufs_debugfs);
 	return 0;
 }
diff --git a/drivers/ufs/core/ufs-hwmon.c b/drivers/ufs/core/ufs-hwmon.c
index aa0b60a0ee8a..2b9673d92573 100644
--- a/drivers/ufs/core/ufs-hwmon.c
+++ b/drivers/ufs/core/ufs-hwmon.c
@@ -61,7 +61,11 @@ static int ufs_hwmon_read(struct device *dev, enum hwmon=
_sensor_types type, u32
 		return -EBUSY;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	err =3D ufshcd_rpm_resume_and_get(hba);
+	if (err) {
+		up(&hba->host_sem);
+		return err;
+	}
=20
 	switch (attr) {
 	case hwmon_temp_enable:
@@ -113,7 +117,11 @@ static int ufs_hwmon_write(struct device *dev, enum hw=
mon_sensor_types type, u32
 		return -EBUSY;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	err =3D ufshcd_rpm_resume_and_get(hba);
+	if (err) {
+		up(&hba->host_sem);
+		return err;
+	}
=20
 	if (val =3D=3D 1)
 		err =3D ufshcd_update_ee_usr_mask(hba, MASK_EE_URGENT_TEMP, 0);
diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 25e392f8ede2..005a70462473 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -554,6 +554,23 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, st=
ruct ufs_hw_queue *hwq)
 	return err;
 }
=20
+/*
+ * Reap the CQ directly so that progress does not depend on interrupt
+ * delivery. ufshcd_compl_one_cqe() updates the OCS under cq_lock before
+ * calling scsi_done(). Holding cq_lock while reading the OCS makes sure t=
hat
+ * the completion has finished once the updated OCS is observed, even if t=
he
+ * CQE was reaped by the interrupt handler.
+ */
+static enum utp_ocs ufshcd_mcq_poll_ocs(struct ufs_hba *hba,
+					struct ufs_hw_queue *hwq,
+					struct ufshcd_lrb *lrbp)
+{
+	ufshcd_mcq_poll_cqe_lock(hba, hwq);
+
+	guard(spinlock_irqsave)(&hwq->cq_lock);
+	return lrbp->utr_descriptor_ptr->header.ocs;
+}
+
 /**
  * ufshcd_mcq_sq_cleanup - Clean up submission queue resources
  * associated with the pending command.
@@ -613,6 +630,23 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int tas=
k_tag)
 			 __func__, id,
 			 FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
=20
+	/*
+	 * For device management commands, there is no order guaranteed between
+	 * OCS update and CUS update, which is why we need to wait here. SCSI
+	 * commands are excluded because the OCS in their UTRD is not updated
+	 * from the CQE.
+	 */
+	if (!err && blk_mq_is_reserved_rq(rq)) {
+		enum utp_ocs ocs;
+
+		err =3D read_poll_timeout(ufshcd_mcq_poll_ocs, ocs,
+					ocs !=3D OCS_INVALID_COMMAND_STATUS, 20,
+					MCQ_POLL_US, false, hba, hwq, lrbp);
+		if (err)
+			dev_err(hba->dev, "%s: OCS not updated. hwq=3D%d, tag=3D%d err=3D%d\n",
+				__func__, id, task_tag, err);
+	}
+
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err =3D -ETIMEDOUT;
=20
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index cf49ad0258e1..19b62cf52410 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -250,13 +250,19 @@ EXPORT_SYMBOL_GPL(ufshcd_us_to_ahit);
=20
 static int ufshcd_read_hci_reg(struct ufs_hba *hba, u32 *val, unsigned int=
 reg)
 {
+	int ret;
+
 	down(&hba->host_sem);
 	if (!ufshcd_is_user_access_allowed(hba)) {
 		up(&hba->host_sem);
 		return -EBUSY;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret) {
+		up(&hba->host_sem);
+		return ret;
+	}
 	ufshcd_hold(hba);
 	*val =3D ufshcd_readl(hba, reg);
 	ufshcd_release(hba);
@@ -350,7 +356,9 @@ static ssize_t wb_on_store(struct device *dev, struct d=
evice_attribute *attr,
 		goto out;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	res =3D ufshcd_rpm_resume_and_get(hba);
+	if (res)
+		goto out;
 	res =3D ufshcd_wb_toggle(hba, wb_enable);
 	ufshcd_rpm_put_sync(hba);
 out:
@@ -421,7 +429,9 @@ static ssize_t enable_wb_buf_flush_store(struct device =
*dev,
 		goto out;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	res =3D ufshcd_rpm_resume_and_get(hba);
+	if (res)
+		goto out;
 	res =3D ufshcd_wb_toggle_buf_flush(hba, enable_wb_buf_flush);
 	ufshcd_rpm_put_sync(hba);
=20
@@ -490,7 +500,9 @@ static ssize_t wb_resize_enable_store(struct device *de=
v,
 		goto out;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	res =3D ufshcd_rpm_resume_and_get(hba);
+	if (res)
+		goto out;
 	res =3D ufshcd_wb_set_resize_en(hba, mode);
 	ufshcd_rpm_put_sync(hba);
=20
@@ -598,7 +610,9 @@ static ssize_t device_lvl_exception_id_show(struct devi=
ce *dev,
 	if (hba->dev_info.wspecversion < 0x410)
 		return -EOPNOTSUPP;
=20
-	ufshcd_rpm_get_sync(hba);
+	err =3D ufshcd_rpm_resume_and_get(hba);
+	if (err)
+		return err;
 	err =3D ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 				      QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID,
 				      0, 0, &exception_id);
@@ -1101,7 +1115,9 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_h=
ba *hba,
 		goto out;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
 	ret =3D ufshcd_read_desc_param(hba, desc_id, desc_index,
 				param_offset, desc_buf, param_size);
 	ufshcd_rpm_put_sync(hba);
@@ -1482,7 +1498,12 @@ static ssize_t _name##_show(struct device *dev,				\
 		up(&hba->host_sem);					\
 		return -ENOMEM;						\
 	}								\
-	ufshcd_rpm_get_sync(hba);					\
+	ret =3D ufshcd_rpm_resume_and_get(hba);				\
+	if (ret) {							\
+		kfree(desc_buf);					\
+		up(&hba->host_sem);					\
+		return ret;						\
+	}								\
 	ret =3D ufshcd_query_descriptor_retry(hba,			\
 		UPIU_QUERY_OPCODE_READ_DESC, QUERY_DESC_IDN_DEVICE,	\
 		0, 0, desc_buf, &desc_len);				\
@@ -1548,7 +1569,9 @@ static ssize_t _name##_show(struct device *dev,				\
 	}								\
 	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
 		index =3D ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
+	ret =3D ufshcd_rpm_resume_and_get(hba);				\
+	if (ret)							\
+		goto out;						\
 	ret =3D ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
 		QUERY_FLAG_IDN##_uname, index, &flag);			\
 	ufshcd_rpm_put_sync(hba);					\
@@ -1608,7 +1631,9 @@ static ssize_t max_number_of_rtt_show(struct device *=
dev,
 		return -EBUSY;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
 	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
 	ufshcd_rpm_put_sync(hba);
@@ -1648,7 +1673,9 @@ static ssize_t max_number_of_rtt_store(struct device =
*dev,
 		goto out;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
=20
 	memflags =3D memalloc_noio_save();
 	shost_for_each_device(sdev, hba->host)
@@ -1700,7 +1727,11 @@ static int wb_read_resize_attrs(struct ufs_hba *hba,
 	}
=20
 	index =3D ufshcd_wb_get_query_index(hba);
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret) {
+		up(&hba->host_sem);
+		return ret;
+	}
 	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 			idn, index, 0, attr_val);
 	ufshcd_rpm_put_sync(hba);
@@ -1760,7 +1791,9 @@ static ssize_t _name##_show(struct device *dev,				\
 	}								\
 	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
 		index =3D ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
+	ret =3D ufshcd_rpm_resume_and_get(hba);				\
+	if (ret)							\
+		goto out;						\
 	if (ufshcd_is_qword_attr(QUERY_ATTR_IDN##_uname))		\
 		ret =3D ufshcd_query_attr_qword(hba,			\
 			UPIU_QUERY_OPCODE_READ_ATTR,			\
@@ -1848,7 +1881,11 @@ static int hid_query_attr(struct ufs_hba *hba, enum =
query_opcode opcode,
 		return -EBUSY;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret) {
+		up(&hba->host_sem);
+		return ret;
+	}
 	ret =3D ufshcd_query_attr(hba, opcode, idn, 0, 0, attr_val);
 	ufshcd_rpm_put_sync(hba);
=20
@@ -2121,7 +2158,9 @@ static ssize_t dyn_cap_needed_attribute_show(struct d=
evice *dev,
 		goto out;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
 	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_DYN_CAP_NEEDED, lun, 0, &value);
 	ufshcd_rpm_put_sync(hba);
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index baf6ae917d36..8df1a2c6abf6 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -150,7 +150,9 @@ static int ufs_bsg_request(struct bsg_job *job)
 		goto out_complete;
 	}
=20
-	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out_complete;
=20
 	msgcode =3D bsg_request->msgcode;
 	switch (msgcode) {
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.=
h
index e55c2a02c1f5..99f654b79035 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -388,6 +388,11 @@ static inline int ufshcd_rpm_get_sync(struct ufs_hba *=
hba)
 	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
 }
=20
+static inline int ufshcd_rpm_resume_and_get(struct ufs_hba *hba)
+{
+	return pm_runtime_resume_and_get(&hba->ufs_device_wlun->sdev_gendev);
+}
+
 static inline int ufshcd_rpm_get_if_active(struct ufs_hba *hba)
 {
 	return pm_runtime_get_if_active(&hba->ufs_device_wlun->sdev_gendev);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd52deb72d21..ddc953b45ce9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1864,7 +1864,9 @@ static ssize_t ufshcd_clkscale_enable_store(struct de=
vice *dev,
 	if (value =3D=3D hba->clk_scaling.is_enabled)
 		goto out;
=20
-	ufshcd_rpm_get_sync(hba);
+	err =3D ufshcd_rpm_resume_and_get(hba);
+	if (err)
+		goto out;
 	ufshcd_hold(hba);
=20
 	hba->clk_scaling.is_enabled =3D value;
@@ -3390,7 +3392,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, =
struct scsi_cmnd *cmd,
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
 	blk_status_t sts;
=20
-	rq->timeout =3D timeout;
+	rq->timeout =3D msecs_to_jiffies(timeout);
 	sts =3D blk_execute_rq(rq, true);
 	if (sts !=3D BLK_STS_OK)
 		return blk_status_to_errno(sts);
@@ -4792,7 +4794,8 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, =
u32 ahit)
=20
 	WRITE_ONCE(hba->ahit, ahit);
 	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
-		ufshcd_rpm_get_sync(hba);
+		if (ufshcd_rpm_resume_and_get(hba))
+			return;
 		ufshcd_hold(hba);
 		/*
 		 * Serialize with the host driver's AHIT control. Skip the
@@ -8064,11 +8067,15 @@ static void ufshcd_set_req_abort_skip(struct ufs_hb=
a *hba, unsigned long bitmap)
  * @hba: Pointer to adapter instance
  * @tag: Tag of the task to be aborted
  *
- * Abort the pending command in device by sending UFS_ABORT_TASK task mana=
gement
- * command, and in host controller by clearing the door-bell register. The=
re can
- * be race between controller sending the command to the device while abor=
t is
- * issued. To avoid that, first issue UFS_QUERY_TASK to check if the comma=
nd is
- * really issued and then try to abort it.
+ * Abort the pending SCSI command in device by sending UFS_ABORT_TASK task
+ * management command, and in host controller by clearing the door-bell
+ * register. There can be race between controller sending the command to t=
he
+ * device while abort is issued. To avoid that, first issue UFS_QUERY_TASK=
 to
+ * check if the command is really issued and then try to abort it.
+ *
+ * Device management commands are not SCSI commands, so no task management
+ * function is issued for them; only the command is cleared in the host
+ * controller.
  *
  * Return: zero on success, non-zero on failure.
  */
@@ -8085,6 +8092,9 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int=
 tag)
=20
 	lrbp =3D scsi_cmd_priv(cmd);
=20
+	if (!ufshcd_is_scsi_cmd(cmd))
+		goto clear_cmd;
+
 	for (poll_cnt =3D 100; poll_cnt; poll_cnt--) {
 		err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_QUERY_TASK,
 					  &resp);
@@ -8130,6 +8140,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int=
 tag)
 		return err;
 	}
=20
+clear_cmd:
 	err =3D ufshcd_clear_cmd(hba, tag);
 	if (err)
 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
@@ -8223,10 +8234,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
=20
-	if (blk_mq_is_reserved_rq(rq))
-		err =3D ufshcd_clear_cmd(hba, tag);
-	else
-		err =3D ufshcd_try_to_abort_task(hba, tag);
+	err =3D ufshcd_try_to_abort_task(hba, tag);
 	if (err) {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
 		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
@@ -10651,8 +10659,14 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba,=
 enum ufs_pm_op pm_op)
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
-	hba->clk_gating.is_suspended =3D false;
-	ufshcd_release(hba);
+	/*
+	 * A failed runtime resume leaves the W-LUN RPM_SUSPENDED, so keep
+	 * is_suspended and the suspend hold for the next resume.
+	 */
+	if (!ret || pm_op !=3D UFS_RUNTIME_PM) {
+		hba->clk_gating.is_suspended =3D false;
+		ufshcd_release(hba);
+	}
 	hba->pm_op_in_progress =3D false;
 	return ret;
 }
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 27c87e62f8e9..47fc785612ad 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2413,7 +2413,9 @@ static void ufs_qcom_write_msi_msg(struct msi_desc *d=
esc, struct msi_msg *msg)
 {
 	struct device *dev =3D msi_desc_to_dev(desc);
 	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
=20
+	host->esi_msg =3D *msg;
 	ufshcd_mcq_config_esi(hba, msg);
 }
=20
@@ -2441,8 +2443,10 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 	struct ufs_qcom_irq *qi;
 	int nr_irqs, ret;
=20
-	if (host->esi_enabled)
-		return 0;
+	if (host->esi_enabled) {
+		ufshcd_mcq_config_esi(hba, &host->esi_msg);
+		goto enable;
+	}
=20
 	/*
 	 * 1. We only handle CQs as of now.
@@ -2480,12 +2484,14 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 		}
 	}
=20
+	host->esi_enabled =3D true;
+
+enable:
 	if (host->hw_ver.major >=3D 6) {
 		ufshcd_rmwl(hba, ESI_VEC_MASK, FIELD_PREP(ESI_VEC_MASK, MAX_ESI_VEC - 1)=
,
 			    REG_UFS_CFG3);
 	}
 	ufshcd_mcq_enable_esi(hba);
-	host->esi_enabled =3D true;
 	return 0;
 }
=20
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 944b2e532a09..d2647695abe3 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -5,6 +5,7 @@
 #ifndef UFS_QCOM_H_
 #define UFS_QCOM_H_
=20
+#include <linux/msi.h>
 #include <linux/reset-controller.h>
 #include <linux/reset.h>
 #include <soc/qcom/ice.h>
@@ -360,6 +361,7 @@ struct ufs_qcom_host {
 	u32 phy_gear;
=20
 	bool esi_enabled;
+	struct msi_msg esi_msg;
=20
 	u32 saved_tx_eq_g1_setting;
 	u32 boot_spare_cfg;
diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchi=
p.c
index bac68f238e1c..87308c9b1070 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -82,6 +82,7 @@ static int ufs_rockchip_rk3576_phy_init(struct ufs_hba *h=
ba)
 		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_PVALUE2, SEL_RX_LAN=
E0 + i), 0x02);
 		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_OPTION, SEL_RX_LANE=
0 + i), 0xf6);
 		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_POWER_SAVING_CTRL, SEL_RX_LAN=
E0 + i), 0x69);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_SAVE_DET_CTRL, SEL_RX_LANE0 +=
 i), 0x18);
 	}
=20
 	/* disable the mphy DME_SET cfg */
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 9c7d31aa6bae..0ee0cf3200d0 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -371,6 +371,9 @@ enum zbc_zone_reporting_options {
=20
 #define ZBC_REPORT_ZONE_PARTIAL 0x80
=20
+#define ZBC_REPORT_ZONES_HEADER_SIZE	64
+#define ZBC_ZONE_DESCRIPTOR_SIZE	64
+
 /* Zone types of REPORT ZONES zone descriptors */
 enum zbc_zone_type {
 	ZBC_ZONE_TYPE_CONV		=3D 0x1,
