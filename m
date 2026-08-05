Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2237D30B53A;
	Wed,  5 Aug 2026 04:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785903930; cv=none; b=Dq/ZRkkaOaPzJV8hGDburd6EqMk/swtjY9kie6ZNPcID377l+S8TRTePJexymqqDzsJ478XgfYnov9LRVwiEFezxTPCSaIeUmGBHlvvIap7Kq7255vXee67H2IJC8x28CjEody+yFdruf+CYv6ZCBrg9bm+2LVTGohi0Xo+B5jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785903930; c=relaxed/simple;
	bh=boh+SgkXewuvZmrcr9+9mjvbpm9kkWo160cYHXAg140=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JIz8LHtJunsXnBjZlGqqNT0XM+wp9GhLEY7dngepIFa0iJTU+rRVP9xkjfRHEzN5azlo6Wk5gGCOIccGovOyYWYZw1Bn2IEwG7/AKtHqppXMFkghFSCRD2xtGHSd9XimletQU7nPbwbOqvkrc0xlCWTCzLSoXvvgMKS7trfmWPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=FJ9237up; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jZZsyDP5; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="FJ9237up";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jZZsyDP5"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 12C93EC01A5;
	Wed,  5 Aug 2026 00:25:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 05 Aug 2026 00:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm3;
	 t=1785903927; x=1785990327; bh=+RzjTXj5GQpB/+M3lDLNY8vs1aCuo4Sr
	8fJWFBZ58YA=; b=FJ9237upnukAmX6ZMavHtEyZGiC79wo5dWBISKin/YDL1cMW
	XEne6oHXnAT/k1ZYyYTYfQe/hOYIwQ5xvzBi8wjp6CSlbbQTWNAjEbuNkg3ikllE
	G/6Gk/TLC1EXg4KPzXma6IkOW2PTkpoMvlqVGcWEh3d2Y3gyS8G5qyLYl0K3m/Ey
	zlxQDaklgQZLCtqQdD3YQgO/XyM2Kt+MUfVnguZAcr/r9QyuG8SCyUGQfmtI7qic
	JPZm+7oF2FT+YgBmmx1GGnys+gy+BHFT/6vFgD4S84de/WSvfGtkfV5fY+34Z1eV
	9kahheSL5q6R1Zkwvk7i0Ic8NntGdVQrr3J1ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785903927; x=
	1785990327; bh=+RzjTXj5GQpB/+M3lDLNY8vs1aCuo4Sr8fJWFBZ58YA=; b=j
	ZZsyDP5Gpvh1c7yJ7d2CyxXCdiRm39juvNVxnN/Qr+KYQICRKAvUR3BjAbDO+hJB
	y1Iy9RN43td7M4WF87fayjG9rXdxiEzEJQNBVWv+U0F13z+xPODdYbHzuvCUmAD5
	WfvOumMUrmYFrFVwIzZcVoDf4dipySd7/h8B1shw1YOVxwjxhQS+LEsUMP98+pRB
	XA3C2kLAIyn2HHb4H8PurcLUDyqBDEnhJ7HEBl2XJu+tdDMyoZ0MOat4beUl2UiL
	O5s8PeBkrn+D1IBg6m66DyLMc9MuQ934s1Wwp0ITkFhlyR7GpblWWXg24GTmvJcc
	fhUg/x66gVLlXmUCckxQg==
X-ME-Sender: <xms:Nrtyar9Gmzd3iGymEmxvTDa6vZyGoyNquyfudwpp3Dqy5yWm1D6u5g>
    <xme:NrtyahwZDlvBu_lg1wptA_vFlcTXUwh_I3gBogR0OJW_r4U0yzATAoFZM9KXqI3RO
    zWyKwstUkmDsXqsUtMs0UWl_mrzdfasYsFwr1YaTgEX84v6cIzlxYrO>
X-ME-Received: <xmr:Nrtyao40OlGBt9peZ_44Fe9xlIYcOIWQA63gwaOEPjZG55dfDEKTM0T8-N4>
X-ME-Proxy-Cause: dmFkZTEz0MQjUAa5o/jjKkpKeyhN5SStrXYr8tCC8Rcjeoay5d9Hwes8hXbaQA3PPsH87d
    zMM7I/3b0kXxczVmygP0/30zrkQGzYVJEhkAWkuKChdzuRHT+4ADO1ZyiIHLx3dnwws5eV
    GPRBHtOVhoS9l6CeJSEIQZdTM863DClSBOHWYaucWOET7sONU3a5DFsFhaHjHTETWmVvrL
    qwOLPGG9RU0GaBlBWEELv0+YDN+CdyhLuz9FITYLx+cDM54SkmwjNGfunemgGQATItnyFX
    +0roGpRM+uwEeJabLT29MrAArsJsAe8rhWe+fBpt1H9WbS5NZupkrkSX7tUf3z8tDvdHOQ
    Uqn1esqDq5z1ZFppNd+0QUQzalmcsnzukskGifpknEDTHmFx72sqmwzKi1Wmt8S1YG3QYM
    0nztV0qdUE10fMm6cFDo9LAdUKRF93Pn+xF2bXuCoFesw76iwLAVBvnSJzWuSlNOFEBeGc
    pEOwEwA0ACxB+t/vQl3hGs0iIZiuv/52UmzxKoc8UqKj7mqvi6mG1aNuKRA26COQPBcQz3
    9j7R+WJZEuJ5GncHPXUQkdmtZNeG8bHIQWU+SG07BAVtTMB//unxeKfUioKqEkZhOiOe7i
    WJcGhVpQK3zkwubkwitW/fq65FldEhU5pgFbxGlx4RhViMDNR1a40zZZ7WNQ
X-ME-Proxy: <xmx:Nrtyao_vUAYbIXatflM-T_V7dlbLsfyULO2ky0n3S3iY0ifQ7TyCFA>
    <xmx:Nrtyato3EdUfMfPOklmvtghVnqtCaDS7QMxoGsNdw3Cywjyrijuw2g>
    <xmx:NrtyaprBYy5yqSaaj-JuB2CKGn5YItM51yewni-ovYXfiQxuCvzUvQ>
    <xmx:Nrtyag1ZoI7jVOIdI4-ICUkcALNVdTNjswzeE8hJxY34lqBVf_EWCQ>
    <xmx:N7tyanZOpc6JoZqDJB9ZLofaKKfK719dUxQraoCz-FfhbA4ftj-m_UrT>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Aug 2026 00:25:26 -0400 (EDT)
Date: Tue, 4 Aug 2026 23:25:24 -0500
From: Ian Bridges <icb@fastmail.org>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: bfa: Replace strlcat() with scnprintf()
Message-ID: <anK7NApeyv03uqXD@dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In preparation for removing the strlcat() API[1], replace its uses
in the symbolic name builders. Each affected function assembles a
fixed sequence of string fragments into one buffer. A single
scnprintf() per function writes the same bytes, including on
truncation, and states the buffer size once instead of once per
append.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
The destination buffers are byte identical to the old code in all
cases, including truncation of oversized fragments and the bytes
past the terminator.

In bfa_fcs_fabric_psymb_init() the patch level if/else disappears
into the format arguments. Both branches append the same OS name
and separator, and printing an empty patch string appends nothing.

The patch was tested as follows.

- A differential harness compiled the old and new composition
  sequences side by side, with struct layouts mirroring the driver
  so unterminated fields overrun into the same neighbor bytes on both sides.
  Directed sweeps over every fragment length, including
  unterminated full arrays, plus 50000 randomized rounds. 257862
  cases, byte identical output in all of them.
- A KUnit oracle suite called the real fabric name builders in a
  QEMU kernel with KASAN, UBSAN and FORTIFY_SOURCE enabled, on the
  base and on the patched branch, against expected byte tables
  generated by the harness. Both runs matched the tables in all
  twelve cases, and the old and new tables are identical, so the
  kernel builds of the old and new code produce the same arrays.
- W=1 builds of the two changed objects on x86 and arm64, zero new
  warnings.
- A QEMU module load and unload smoke test of the patched bfa.ko
  passed. No hardware was available to test on, so runtime coverage
  comes from the KUnit oracle rather than device testing.

 drivers/scsi/bfa/bfa_fcs.c       | 81 +++++++-------------------------
 drivers/scsi/bfa/bfa_fcs_lport.c | 36 +++++---------
 2 files changed, 29 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 9b57312f43f5..8bf0d0c6b38f 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -760,50 +760,15 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
-	/* Model name/number */
-	strscpy(port_cfg->sym_name.symname, model,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		BFA_SYMNAME_MAXLEN);
-
-	/* Driver Version */
-	strlcat(port_cfg->sym_name.symname, driver_info->version,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		BFA_SYMNAME_MAXLEN);
-
-	/* Host machine name */
-	strlcat(port_cfg->sym_name.symname,
-		driver_info->host_machine_name,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		BFA_SYMNAME_MAXLEN);
-
-	/*
-	 * Host OS Info :
-	 * If OS Patch Info is not there, do not truncate any bytes from the
-	 * OS name string and instead copy the entire OS info string (64 bytes).
-	 */
-	if (driver_info->host_os_patch[0] == '\0') {
-		strlcat(port_cfg->sym_name.symname,
-			driver_info->host_os_name,
-			BFA_SYMNAME_MAXLEN);
-		strlcat(port_cfg->sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-	} else {
-		strlcat(port_cfg->sym_name.symname,
-			driver_info->host_os_name,
-			BFA_SYMNAME_MAXLEN);
-		strlcat(port_cfg->sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-
-		/* Append host OS Patch Info */
-		strlcat(port_cfg->sym_name.symname,
-			driver_info->host_os_patch,
-			BFA_SYMNAME_MAXLEN);
-	}
+	/* Model | Driver Version | Host machine name | Host OS | OS patch */
+	scnprintf(port_cfg->sym_name.symname, BFA_SYMNAME_MAXLEN,
+		  "%s%s%s%s%s%s%s%s%s",
+		  model, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		  driver_info->version, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		  driver_info->host_machine_name,
+		  BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		  driver_info->host_os_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		  driver_info->host_os_patch);
 
 	/* null terminate */
 	port_cfg->sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
@@ -821,27 +786,13 @@ bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric)
 
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
-	/* Model name/number */
-	strscpy(port_cfg->node_sym_name.symname, model,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->node_sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-
-	/* Driver Version */
-	strlcat(port_cfg->node_sym_name.symname, (char *)driver_info->version,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->node_sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-
-	/* Host machine name */
-	strlcat(port_cfg->node_sym_name.symname,
-		driver_info->host_machine_name,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->node_sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
+	/* Model | Driver Version | Host machine name */
+	scnprintf(port_cfg->node_sym_name.symname, BFA_SYMNAME_MAXLEN,
+		  "%s%s%s%s%s%s",
+		  model, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		  driver_info->version, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		  driver_info->host_machine_name,
+		  BFA_FCS_PORT_SYMBNAME_SEPARATOR);
 
 	/* null terminate */
 	port_cfg->node_sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 2df399c537c1..9ac761272132 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2599,19 +2599,15 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	strscpy(hba_attr->driver_version, (char *)driver_info->version,
 		sizeof(hba_attr->driver_version));
 
-	strscpy(hba_attr->os_name, driver_info->host_os_name,
-		sizeof(hba_attr->os_name));
-
 	/*
 	 * If there is a patch level, append it
 	 * to the os name along with a separator
 	 */
-	if (driver_info->host_os_patch[0] != '\0') {
-		strlcat(hba_attr->os_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(hba_attr->os_name));
-		strlcat(hba_attr->os_name, driver_info->host_os_patch,
-				sizeof(hba_attr->os_name));
-	}
+	scnprintf(hba_attr->os_name, sizeof(hba_attr->os_name), "%s%s%s",
+		  driver_info->host_os_name,
+		  driver_info->host_os_patch[0] != '\0' ?
+			BFA_FCS_PORT_SYMBNAME_SEPARATOR : "",
+		  driver_info->host_os_patch);
 
 	/* Retrieve the max frame size from the port attr */
 	bfa_fcs_fdmi_get_portattr(fdmi, &fcs_port_attr);
@@ -4589,13 +4585,10 @@ bfa_fcs_lport_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		 * to that of the base port.
 		 */
 
-		strscpy(symbl,
-			(char *)&(bfa_fcs_lport_get_psym_name
-			 (bfa_fcs_get_base_port(port->fcs))),
-			sizeof(symbl));
-
-		strlcat(symbl, (char *)&(bfa_fcs_lport_get_psym_name(port)),
-			sizeof(symbl));
+		scnprintf(symbl, sizeof(symbl), "%s%s",
+			  (char *)&(bfa_fcs_lport_get_psym_name
+			   (bfa_fcs_get_base_port(port->fcs))),
+			  (char *)&(bfa_fcs_lport_get_psym_name(port)));
 	} else {
 		psymbl = (u8 *) &(bfa_fcs_lport_get_psym_name(port));
 	}
@@ -5116,13 +5109,10 @@ bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		 * For Vports, we append the vport's port symbolic name
 		 * to that of the base port.
 		 */
-		strscpy(symbl, (char *)&(bfa_fcs_lport_get_psym_name
-			(bfa_fcs_get_base_port(port->fcs))),
-			sizeof(symbl));
-
-		strlcat(symbl,
-			(char *)&(bfa_fcs_lport_get_psym_name(port)),
-			sizeof(symbl));
+		scnprintf(symbl, sizeof(symbl), "%s%s",
+			  (char *)&(bfa_fcs_lport_get_psym_name
+			   (bfa_fcs_get_base_port(port->fcs))),
+			  (char *)&(bfa_fcs_lport_get_psym_name(port)));
 	}
 
 	len = fc_rspnid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-- 
2.47.3

