Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F68199953;
	Thu, 10 Oct 2024 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578060; cv=none; b=eL7Lw8WmHELaQB7S1MVk8k/V35ekqiMypyP6QKpqjGVjYnNEfkVh2JzZx7KuuN7h5m0vgiG7t/Y7U34lR9lR7MY2+Of3lvZ4Vp392butV0ew1hSFlkrRzKrQJSxn+qPzGzRJvtrVpRI8Nq9ckVQm8Z8oZPgd1PNnOEaNvmeV2dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578060; c=relaxed/simple;
	bh=jX1uoF/xVPYo21MqB7dsU8yhpGsO+KbGGO9Ppcm5jfw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iOzyuW3pPBHb2XteIIiEJ1UR9lav6ymXWkaJ4XPwsFEP1FUm2vp6oGmc902TwdY9DDzq06YPgJkYwiUyu66NkCRv0OI6+tFAmuqyLsm3HLXjlxFMQ7+VAdXz2/7qJHDyIpVrQlyvSoMzSSH43seK+Su8NdQy2oKBdNVOFFpce8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=uGohvMJK; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=xbAygLX9; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="uGohvMJK";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="xbAygLX9"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com BBD4AE0017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728578055; bh=+YjavEWhSNeqF2WBLHzVdKYfyqUtmnkfa9L0UPfNSw4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=uGohvMJKhqAraKBMBms61jVH/S6Lcc7AQeNca6zAUERMsfu5t5cKdiNWgXnB76meS
	 8zrLNKAaHojpOQHbiq/3IvFubJzXFC+KNyzyX7oCaVaRplN8JRsZvYZv/rGngECbr+
	 jl9a9pueLQYNeT3fOAyCia7emsLD3KSbKFDTrlHyUkqwI/rT+3oQuqBguf+C4WUq3K
	 avoy39uHZbn8ulGQ2Jh58utnK6HIrPfcjZXaN3mC2lh2EPS6sEEiQ5sGmbUo7LzegA
	 Vb39WtIdIUCVfhH0O1uPYy9YE2l6GOyLbZ6ouCQSsPDvs5H7t2UgBEARMHDBzizbU8
	 ofm+opMrDL+uA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728578055; bh=+YjavEWhSNeqF2WBLHzVdKYfyqUtmnkfa9L0UPfNSw4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=xbAygLX9AwcWMh0g1BZf5vqGiuvRGIVw9hR420PIZOH7xvIF5MPPzmuU6Y1u0Z1Ze
	 2JsF4goTz3+k6+dzaM6f3L4/M362Pfr9nv/ZnjLDVDUJDt/aS76CTDMrO9tJq2fc66
	 pf8lvvA3vXQANrq2GWhaGBh9Bhnou+CQ7UuUKnlkx74OFiKSnh+WDwLK3gNZUsETns
	 kOZKjVgE7PCwLgqRqtkx8W/nF5tW0Zx43dgAwmem3A/7yqfV2N+cWoKqiC4MWIb/Qd
	 UX3lU95wKwGtCWvvH5YGKVllrnXWWkOwJu/wDxz+mCuG7byXyVPj8tsU3mexqlwysV
	 wRVf8AsRMs0xA==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v3 2/3] scsi: qla2xxx: Make target send correct LOGO
Date: Thu, 10 Oct 2024 19:32:36 +0300
Message-ID: <20241010163236.27969-3-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241010163236.27969-1-a.kovaleva@yadro.com>
References: <20241010163236.27969-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-06.corp.yadro.com (172.17.10.110) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Upon removing the ACL from the target, it sends a LOGO command to the
initiator to break the connection. But HBA fills port_name and port_id
of the LOGO command with all zeroes, which is not valid. The initiator
sends a reject for this command, but it is not being processed on the
target, since it assumes LOGO can never fail. This leaves a system in a
state where the initiator thinks it is still logged in to the target and
can send commands to it, but the target ignores all incoming commands
from this initiator.

If, in such a situation, the initiator sends some command (e.g. during a
scan), after not receiving a response for a timeout duration, it sends
ABORT for the command. After a timeout on receiving an ABORT response,
the initiator sends LOGO to the target. Only after that, the initiator
can successfully relogin to the target and restore the connection. In
the end, this whole situation hangs the system for approximately a
minute.

By default, the driver sends a LOGO command to HBA filling only port_id,
expecting HBA to match port_id with the correct port_name from it's
internal table. HBA doesn't do that, instead filling these fields with
all zeroes.

This patch makes the driver send a LOGO command to HBA with port_name
and port_id in the I/O PARMETER fields. HBA then copies these values to
corresponding fields in the LOGO command frame.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0b41e8a06602..90026fca14dc 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2486,6 +2486,17 @@ qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
 	logio->vp_index = sp->vha->vp_idx;
+	logio->io_parameter[0] = cpu_to_le32(sp->vha->d_id.b.al_pa |
+				 sp->vha->d_id.b.area << 8 |
+				 sp->vha->d_id.b.domain << 16);
+	logio->io_parameter[1] = cpu_to_le32(sp->vha->port_name[3] |
+				 sp->vha->port_name[2] << 8 |
+				 sp->vha->port_name[1] << 16 |
+				 sp->vha->port_name[0] << 24);
+	logio->io_parameter[2] = cpu_to_le32(sp->vha->port_name[7] |
+				 sp->vha->port_name[6] << 8 |
+				 sp->vha->port_name[5] << 16 |
+				 sp->vha->port_name[4] << 24);
 }
 
 static void
-- 
2.40.1

