Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF19192D6C;
	Wed,  9 Oct 2024 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472671; cv=none; b=VcqNi03Nv7KY3U3f68ZXVqxj+q5axAx1i79HQkt8GL/u0riC9TgLrDsOYRi4H/vPQ6DfYlmimfho6P8sNcLKU8HqRZYVtlOcx297bl/5uGS5P+NGcWoSdWAaRFnzrdJXMeUQ218UEJqxFsHtM6c+thyea8ScvXyk4WYuJr1dGdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472671; c=relaxed/simple;
	bh=L3xl7Y45JnJJvfxHv9fI4yzTm9K8ZaJXo9/cApROCTo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJuq9Eow7ZtrcqNbMKGmQx3b/OBQS2JhUZyVMj5UUc91yugDy7rSIBfp5XXnTb5BL2x9YCYsRSG/rxfy481VNSknqzOXaSjqhMF/nOLtF8HsntJnW/2Rak8qkEpY0ja4HjzHV8NHSjHhnwbraqKMpCfi92rti8RnPNBygbKOIhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=nxht8hmS; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=EUWTp1Jr; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="nxht8hmS";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="EUWTp1Jr"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 74B68E0015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728472667; bh=cWg6uv3EM0obnieXASGAm1ATa7D8mOki8svgc34Ic6c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=nxht8hmSBW3UmeW9u5Kw7fwlr8wUT02Z5lm+Lm8gIdAmYC29+2MUhPZjvltOQm0qt
	 T3Fowhe6OYmXB5kgHK2Br/wrGEeTHohDV0UVItLCyHPjyL879Jmp/kJvptRhyDziwT
	 QVI9DcrfzVfG08J0PqqDmVVn0JMj82wnFoqDuTNigCyt4TYIgOb1BaUCRbPVH4NRVl
	 h5vAAh1eRANSr9aZk6SP9mHc90K0ZSPSsKfzXUlgrfJAYpZsoH90F2Mocba0GtuyOl
	 MXmKuUVzVdheiCca7+ej7A9SYV0Y6TtptffRAZwNARXtykV3kTJiSBkcm2AYN7UkkP
	 7IqJI7C60pFOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728472667; bh=cWg6uv3EM0obnieXASGAm1ATa7D8mOki8svgc34Ic6c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=EUWTp1Jrndwijvbu06GzBtfcaG6sthgKuIGVhdXfMvMdt8tzyfmd6J/6KdAjlfrzZ
	 6jF1Ew6edOmn7nu5FNZcNd3J8U9OhUVtTaOET7H35XST2Rnvkithg6GQ3OanozlFmQ
	 BCRVviZzYtKnSFQGlsCgpk1GFcWRg0Kg/rSKAllnTiFqmmAvsQ9dzXVoRmYUqiviXl
	 E6pD8Gqq3h80Aau2z3z6QqwVuUaQCzp1aCXmvtuIHZFR3nJc1QsxZT+pPMKKOQ4mjz
	 iP4OyYYSamF2POWDeI3ylBYbGw9xALHNMwSIteLd6OgBS8yQwvcdyeWHkF8b4Jsi22
	 3sbSePMc0amhA==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@cavium.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v2 2/3] scsi: qla2xxx: Make target send correct LOGO
Date: Wed, 9 Oct 2024 14:16:53 +0300
Message-ID: <20241009111654.4697-3-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241009111654.4697-1-a.kovaleva@yadro.com>
References: <20241009111654.4697-1-a.kovaleva@yadro.com>
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

