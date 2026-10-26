Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031163;
	b=GVbcNCyaxFrySj4BDrEO/GSnufljMJ5TUM0FyxjAVpmLmE0U27BXVWcSJHp+G0463RDk
	 dWAFsiKomSv1BnEu5pBnHPWJgTVd9bH0J2agIbiCYHstsQXeFa9xcM08JSSvM8C3j+MDm
	 yCTkItIWu3iI3Rdclfn1S7ZJo60rhLtw0j9ztOEq7rqErgW2eslevudH4GdEvOtnSLLQP
	 x6H+oDxvwm9Wm9WET6R9NOi4euqCfgnayGsZ8maTePlCZ2W2JAMAVqj/l6jd8f83/NKYC
	 pMnC8jDURsHJlPKdnXT5kC4w1J9VugKfbTojqb3aNbJiElg6A89WqdEIidpB06wtzdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031163;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZMWmWuyZ32nAi1bHf1mmNRSx7Xxi0kE66x9N1Wp8g1Y=;
	b=O8U25AraDfIGN3sIRxerUH5nyDKmXnBhGzcHIQAkxqW1n/SGC1Dk0E0RzeaYmZr1yCBh
	 tOP5piIRkJ8xfGMh2LZBsfS0ucCGuBqvKSPWafcTTFSFCC8ZorEMFwPQftVBeFu+ITPcW
	 lCyqWkO8htSG3kIdOqW/aRv07j83pPkZtdYYJ/k4y33AHQDMVag8aPwNkBuFtK7EZHlwV
	 gvPg8e6Ve39QLb2Nvo/ASKG7pI/+nIBzfjvafttjLeaEksmL2qIGyO0sP0fN2Dews0Dpf
	 GWfaA//0wIeCvLjTuT6YNWxkl9qBFeVkiMkxj/ej2dr3ExzFQZ4ol/vPwP8AiZNKsAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoxPLMmh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4DE606A329;
	Mon, 26 Oct 2026 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoxPLMmh
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031162;
	b=Ukq6slnESKka3TDpuya5b5DkkIRerctw10pCa8eNf7Hd2zzp7Z+EK5IkvA05XqYtZWUY
	 /rlT5TLGpueQ/MGdYjL8cqEL1jJzZPFzqnwrsLKA0fCEExN5C/hFMWmgaNrRBAxQOTDkD
	 XIIPaPClJBOaVapkVSM3/o1py2//3gduL11LCZDDaL1PJWAQj+R8xFPEykjS8SkKei7dL
	 iAAaua2juMdeqzk7oOUZtjI439L6oe8d8nGL5LmigomdSQxA/agbX/RU/wLsSRS5UOBn2
	 zo5TGqsJg15zN53CT8pS7q888HFRmT5B18Y5yVrh33xr6RyzAuJpNwBLIcKBTa6KuMQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031162;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZMWmWuyZ32nAi1bHf1mmNRSx7Xxi0kE66x9N1Wp8g1Y=;
	b=ksWSTZx+5hv7r3sUQQWsJqE4U3SRNaG5bZ4VmciPEkPW6BSaATQpKgbXRYmVabhCcIQD
	 w21gUDlwaovhehmE/p59Lf5NrGDZHKnDAZwBMjfk/IpJ+1ALN6UUEPSuBjbaNsBPc9gSJ
	 HLV7Pq23O2FfVKQFV7dDPF954IEL9tI+16T4IHKZFiEDwTUKKqMiAbGKpC0X0K68UAirB
	 3zpwhbDNy9ZkoYL8OUQn/WEp/wJMeNL8BHVtDyvG+Q18K3S8zKrzIlf3I3anLVD8Fb9bb
	 xLrYkzPFhTqb4aZQl9PIjcg4s+IgrI1tgBeT7VARKJt/vHO5eubJtSTIfreqUnOO2Tw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5CB001F031ED;
	Mon, 26 Oct 2026 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031162;
	bh=ZMWmWuyZ32nAi1bHf1mmNRSx7Xxi0kE66x9N1Wp8g1Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OoxPLMmhLQBzKZmwSJUnFWxSPccCy2dbYA4Z2LNY+8FjmJyQxcoPqqM/vtpy1C3F6
	 TbiU10Iy4RQlZ8O0XbZHiyYgGZwIY60+ZlzQjh2+azq2sVID62WVeu7x3TAzqQl/RL
	 2XOg3V8MNTDFSTy0uf+tvbiWHbuTt6Utf02Lq17ZdSgCFsoSLkkHjt28x0H+lJpGS4
	 Wfy8fL+PNAqX/MNdYygVXbRTlpJ5Sto5SYnFxEM58Ldx27PbO3zBOUFZmWbrYCAVwo
	 PCO/ay7qQTSGoYUW2u3RA+O7ArE7qU6IZ3JT8pfMlLWB/6oLOToDvW1gyaI4JMxcUR
	 LK7M7I9ClUkoQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A6B1944DB1;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:44 -0500
Subject: [PATCH v16 12/12] scsi: ibmvfc: handle extended FPIN events
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-12-a900aa657ed5@linux.ibm.com>
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
In-Reply-To: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=17482;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=oG07Ku2YmDffqSqUBxbjt75fH4CFVPVrXP0/3PAwXsU=;
 b=EczqmXUr8VIMul2bcp2hbK4vrNYUxxy5R2cF+6oPT+zDxaCAZnlyrpmIGkWWeE9U18i0YibuQ
 vCxMvlWzMLbDu+/k/btHHcWYWMkf/y16X1WpCiILO/ezfTwlD7Uc03S
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

Implement support for extended FPIN messages received via the
asynchronous sub-queue, completing full FPIN functionality.

Extended FPIN messages provide more detailed information about fabric
events compared to basic FPIN messages, including specific event types,
modifiers, thresholds, event counts, and severity.

Add ibmvfc_ext_fpin_to_desc() to convert extended FPIN messages from
async sub-queue format to fc_els_fpin structures with complete descriptor
information. Update ibmvfc_process_async_work() and ibmvfc_handle_async()
to zero node_name and dispatch to ibmvfc_ext_fpin_to_desc() when the
IBMVFC_ASYNC_IS_FPIN_EXT flag is set.

Extend ibmvfc_common_fpin_to_desc() with a severity parameter so that
extended FPIN events can propagate the severity value from the VIOS when
IBMVFC_FPIN_SEVERITY_VALID is set, rather than always defaulting to
FPIN_CONGN_SEVERITY_WARNING.

Set the IBMVFC_CAN_HANDLE_FPIN_EXT capability bit (0x800) during login
to inform the VIOS that the client can process extended FPIN messages.
Add the IBMVFC_CAN_CLS_CRQ_PRE_DMP capability bit (0x400) definition
for the intervening protocol-defined capability. Also add the
IBMVFC_SUPPORT_FPIN_EXT response capability bit definition used to gate
extended FPIN processing.

In ibmvfc_process_async_work(), use goto to bypass the generic "FPIN
event received, unable to process" error message when a more specific
diagnostic has already been emitted for invalid or unsupported extended
FPIN events.

Add KUnit tests to exercise extended FPIN event handling across all
FPIN status and event type combinations.

struct ibmvfc_async_subq_fpin uses volatile on its valid field,
consistent with the existing ibmvfc_crq, ibmvfc_async_crq, and
ibmvfc_async_sub_crq structs in ibmvfc.h, all of which mark their
hardware-owned ring-buffer valid field volatile to prevent the compiler
from caching or eliminating reads of memory written directly by the VIOS.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c  |  88 +++++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h       |  31 ++++++++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 148 +++++++++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 4d4ebe5f6f12..c8b12b4cf6cf 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1593,6 +1593,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->capabilities |= cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
 		login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN_EXT);
 		if (vhost->nvme_enabled) {
 			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
 			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
@@ -3324,6 +3325,11 @@ static size_t ibmvfc_fpin_size_helper(u8 fpin_status)
  *			IBMVFC_AE_FPIN_PORT_DEGRADED only
  * @event_count:	link integrity event count (big-endian); used for
  *			IBMVFC_AE_FPIN_PORT_DEGRADED only
+ * @severity:		congestion severity value; stored in congestion
+ *			descriptors (IBMVFC_AE_FPIN_LINK_CONGESTED,
+ *			IBMVFC_AE_FPIN_CONGESTION_CLEARED,
+ *			IBMVFC_AE_FPIN_PORT_CONGESTED,
+ *			IBMVFC_AE_FPIN_PORT_CLEARED)
  *
  * Return:
  * NULL     - unable to allocate structure or unrecognised fpin_status
@@ -3331,7 +3337,7 @@ static size_t ibmvfc_fpin_size_helper(u8 fpin_status)
  */
 static struct fc_els_fpin *
 ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 type, __be16 modifier,
-			   __be32 threshold, __be32 event_count)
+			   __be32 threshold, __be32 event_count, __u8 severity)
 {
 	struct fc_fn_peer_congn_desc *pdesc;
 	struct fc_fn_congn_desc *cdesc;
@@ -3359,7 +3365,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 type, __be16 modi
 		cdesc->event_type = type;
 		cdesc->event_modifier = modifier;
 		cdesc->event_period = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD);
-		cdesc->severity = FPIN_CONGN_SEVERITY_WARNING;
+		cdesc->severity = severity;
 		break;
 	case IBMVFC_AE_FPIN_PORT_CONGESTED:
 	case IBMVFC_AE_FPIN_PORT_CLEARED:
@@ -3436,7 +3442,7 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
 	return ibmvfc_common_fpin_to_desc(crq->fpin_status, cpu_to_be64(wwpn),
 					  type, cpu_to_be16(0),
 					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
-					  cpu_to_be32(1));
+					  cpu_to_be32(1), FPIN_CONGN_SEVERITY_WARNING);
 }
 
 /**
@@ -3476,7 +3482,47 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin, u64 wwpn)
 	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, cpu_to_be64(wwpn),
 					  type, cpu_to_be16(0),
 					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
-					  cpu_to_be32(1));
+					  cpu_to_be32(1), FPIN_CONGN_SEVERITY_WARNING);
+}
+
+/**
+ * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
+ * containing a descriptor.
+ * @ibmvfc_fpin: Pointer to async subq FPIN data
+ * @wwpn:	attached port WWPN (host-endian)
+ *
+ * Allocate a struct fc_els_fpin containing a descriptor and populate
+ * based on data from *ibmvfc_fpin.
+ *
+ * Return:
+ * NULL     - unable to allocate structure
+ * non-NULL - pointer to populated struct fc_els_fpin
+ */
+static struct fc_els_fpin *
+ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin, u64 wwpn)
+{
+	u8 flags = ibmvfc_fpin->fpin_data.flags;
+	__be32 threshold = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD);
+	__be16 modifier = 0;
+	__be32 count = cpu_to_be32(1);
+	__be16 type = 0;
+	__u8 severity = FPIN_CONGN_SEVERITY_WARNING;
+
+	if (flags & IBMVFC_FPIN_EVENT_TYPE_VALID)
+		type = ibmvfc_fpin->fpin_data.event_type;
+	if (flags & IBMVFC_FPIN_MODIFIER_VALID)
+		modifier = ibmvfc_fpin->fpin_data.event_type_modifier;
+	if (flags & IBMVFC_FPIN_THRESHOLD_VALID)
+		threshold = ibmvfc_fpin->fpin_data.event_threshold;
+	if (flags & IBMVFC_FPIN_EVENT_COUNT_VALID)
+		count = ibmvfc_fpin->fpin_data.event_data.event_count;
+	if (flags & IBMVFC_FPIN_SEVERITY_VALID)
+		severity = ibmvfc_fpin->fpin_data.event_data.severity;
+
+	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status,
+					  cpu_to_be64(wwpn), type,
+					  modifier, threshold, count,
+					  severity);
 }
 
 /**
@@ -3517,6 +3563,7 @@ static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
 VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
 {
 	struct ibmvfc_async_sub_crq *subq = NULL;
+	struct ibmvfc_async_subq_fpin *sqfpin;
 	struct ibmvfc_async_work *aw;
 	struct ibmvfc_async_crq *crq = NULL;
 	struct ibmvfc_target *tgt;
@@ -3533,7 +3580,10 @@ VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
 		subq = &aw->event.subq;
 		scsi_id = 0;
 		wwpn = subq->wwpn;
-		node_name = (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) ? 0 : subq->id.node_name;
+		if (subq->flags & (IBMVFC_ASYNC_IS_FPIN_EXT | IBMVFC_ASYNC_ID_IS_ASSOC_ID))
+			node_name = 0;
+		else
+			node_name = subq->id.node_name;
 	} else {
 		crq = &aw->event.async_crq;
 		scsi_id = crq->scsi_id;
@@ -3563,8 +3613,26 @@ VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
 
 	if (crq)
 		fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
-	else
-		fpin = ibmvfc_full_fpin_to_desc(subq, tgt->wwpn);
+	else {
+		static_assert(sizeof(struct ibmvfc_async_subq_fpin) ==
+			      sizeof(struct ibmvfc_async_sub_crq));
+		static_assert(offsetof(struct ibmvfc_async_subq_fpin, fpin_data) ==
+			      offsetof(struct ibmvfc_async_sub_crq, nport_id));
+		sqfpin = (struct ibmvfc_async_subq_fpin *)subq;
+		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) == 0) {
+			fpin = ibmvfc_full_fpin_to_desc(subq, tgt->wwpn);
+		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
+			dev_err_ratelimited(vhost->dev,
+					    "Invalid extended FPIN event received\n");
+			goto skip_generic_error;
+		} else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
+			dev_err_ratelimited(vhost->dev,
+					    "Unexpected extended FPIN event received\n");
+			goto skip_generic_error;
+		} else {
+			fpin = ibmvfc_ext_fpin_to_desc(sqfpin, tgt->wwpn);
+		}
+	}
 
 	if (fpin) {
 		fc_host_fpin_rcv(tgt->vhost->host,
@@ -3574,6 +3642,7 @@ VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
 	} else
 		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to process\n");
 
+ skip_generic_error:
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
  free:
 	scsi_host_put(aw->vhost->host);
@@ -3608,7 +3677,10 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq_event *ae,
 		link_state = subq->link_state;
 		scsi_id = 0;
 		wwpn = subq->wwpn;
-		node_name = subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID ? 0 : subq->id.node_name;
+		if (subq->flags & (IBMVFC_ASYNC_IS_FPIN_EXT | IBMVFC_ASYNC_ID_IS_ASSOC_ID))
+			node_name = 0;
+		else
+			node_name = subq->id.node_name;
 	} else {
 		async_crq = &ae->async_crq;
 		event = be64_to_cpu(async_crq->event);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index f77966c85b0e..bce5183f08a4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -210,6 +210,8 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_CAN_USE_WWPN_ALL		0x080
 #define IBMVFC_USE_ASYNC_SUBQ		0x100
 #define IBMVFC_CAN_USE_NOOP_CMD		0x200
+#define IBMVFC_CAN_CLS_CRQ_PRE_DMP	0x400
+#define IBMVFC_CAN_HANDLE_FPIN_EXT	0x800
 	__be64 node_name;
 	struct srp_direct_buf async;
 	u8 partition_name[IBMVFC_MAX_NAME];
@@ -261,6 +263,7 @@ struct ibmvfc_npiv_login_resp {
 #define IBMVFC_SUPPORT_WWPN_ALL		0x0400
 #define IBMVFC_ASYNC_SUBQ		0x0800
 #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
+#define IBMVFC_SUPPORT_FPIN_EXT		0x2000
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
 	__be64 max_dma_len;
@@ -786,6 +789,34 @@ struct ibmvfc_async_sub_crq {
 	} id;
 } __packed __aligned(8);
 
+struct ibmvfc_fpin_data {
+#define IBMVFC_FPIN_EVENT_TYPE_VALID	0x01
+#define IBMVFC_FPIN_MODIFIER_VALID	0x02
+#define IBMVFC_FPIN_THRESHOLD_VALID	0x04
+#define IBMVFC_FPIN_SEVERITY_VALID	0x08
+#define IBMVFC_FPIN_EVENT_COUNT_VALID	0x10
+	u8 flags;
+	u8 reserved[3];
+	__be16 event_type;
+	__be16 event_type_modifier;
+	__be32 event_threshold;
+	union {
+		u8 severity;
+		__be32 event_count;
+	} event_data;
+} __packed __aligned(8);
+
+struct ibmvfc_async_subq_fpin {
+	volatile u8 valid;
+	u8 flags;
+	u8 link_state;
+	u8 fpin_status;
+	__be16 event;
+	__be16 pad;
+	__be64 wwpn;
+	struct ibmvfc_fpin_data fpin_data;
+} __packed __aligned(8);
+
 enum ibmvfc_async_crq_type {
 	IBMVFC_ASYNC_CRQ_MAIN = 0,
 	IBMVFC_ASYNC_CRQ_SUB,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
index b867cfe3138d..3ba3b2e37a9e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
@@ -3,6 +3,7 @@
 #include <kunit/visibility.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_els.h>
 #include <linux/list.h>
 #include <linux/delay.h>
 #include "ibmvfc.h"
@@ -364,9 +365,156 @@ static void ibmvfc_full_fpin_test(struct kunit *test)
 	scsi_host_put(vhost->host);
 }
 
+#define IBMVFC_TEST_FPIN_EXT_TARGET(fs, ev, stat) do {				\
+	struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };	\
+	memset(&crq, 0, sizeof(crq));						\
+	crq.valid = 0x80;							\
+	crq.flags = IBMVFC_ASYNC_IS_FPIN_EXT;					\
+	crq.link_state = IBMVFC_AE_LS_LINK_UP;					\
+	crq.fpin_status = (fs);							\
+	crq.event = cpu_to_be16(IBMVFC_AE_FPIN);				\
+	crq.wwpn = cpu_to_be64(tgt->wwpn);					\
+	crq.fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;			\
+	crq.fpin_data.event_type = cpu_to_be16((ev));				\
+	ae.subq = *(struct ibmvfc_async_sub_crq *)&crq;				\
+	pre = READ_ONCE(rport->fpin_stats.stat);				\
+	ibmvfc_run_async_work(wq, vhost, &ae);					\
+	post = READ_ONCE(rport->fpin_stats.stat);				\
+	KUNIT_EXPECT_GT(test, post, pre);					\
+} while (0)
+
+#define IBMVFC_TEST_FPIN_EXT_HOST(fs, ev, stat) do {				\
+	struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };	\
+	memset(&crq, 0, sizeof(crq));						\
+	crq.valid = 0x80;							\
+	crq.flags = IBMVFC_ASYNC_IS_FPIN_EXT;					\
+	crq.link_state = IBMVFC_AE_LS_LINK_UP;					\
+	crq.fpin_status = (fs);							\
+	crq.event = cpu_to_be16(IBMVFC_AE_FPIN);				\
+	crq.wwpn = cpu_to_be64(tgt->wwpn);					\
+	crq.fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;			\
+	crq.fpin_data.event_type = cpu_to_be16((ev));				\
+	ae.subq = *(struct ibmvfc_async_sub_crq *)&crq;				\
+	pre = READ_ONCE(fc_host->fpin_stats.stat);				\
+	ibmvfc_run_async_work(wq, vhost, &ae);					\
+	post = READ_ONCE(fc_host->fpin_stats.stat);				\
+	KUNIT_EXPECT_GT(test, post, pre);					\
+} while (0)
+
+/**
+ * ibmvfc_extended_fpin_test - unit test for extended FPIN events
+ * @test: pointer to kunit structure
+ *
+ * Return: void
+ */
+static void ibmvfc_extended_fpin_test(struct kunit *test)
+{
+	enum ibmvfc_ae_fpin_status fs;
+	struct ibmvfc_async_subq_fpin crq;
+	struct workqueue_struct *wq;
+	struct ibmvfc_target *tgt;
+	struct ibmvfc_host *vhost;
+	struct fc_host_attrs *fc_host;
+	struct fc_rport *rport;
+	unsigned long flags;
+	u64 pre, post;
+
+	vhost = ibmvfc_get_first_vhost();
+	if (!vhost)
+		kunit_skip(test, "No ibmvfc devices available");
+
+	if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "Extended FPIN not supported");
+	}
+
+	wq = alloc_ordered_workqueue("ibmvfc-kunit-fpin", 0);
+	if (!wq) {
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "Failed to allocate workqueue");
+	}
+
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
+	if (vhost->scsi_scrqs.num_targets < 1) {
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		destroy_workqueue(wq);
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "No targets");
+	}
+	tgt = NULL;
+	rport = NULL;
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
+		if (tgt->rport &&
+		    tgt->rport->port_state == FC_PORTSTATE_ONLINE &&
+		    (tgt->rport->roles & (FC_PORT_ROLE_FCP_TARGET | FC_PORT_ROLE_NVME_TARGET))) {
+			rport = tgt->rport;
+			get_device(&rport->dev);
+			kref_get(&tgt->kref);
+			break;
+		}
+	}
+	if (!rport) {
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		destroy_workqueue(wq);
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "No suitable online target rport found");
+	}
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+
+	fc_host = shost_to_fc_host(vhost->host);
+
+	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
+		switch (fs) {
+		case IBMVFC_AE_FPIN_LINK_CONGESTED:
+			IBMVFC_TEST_FPIN_EXT_HOST(fs, FPIN_CONGN_CLEAR, cn_clear);
+			IBMVFC_TEST_FPIN_EXT_HOST(fs, FPIN_CONGN_LOST_CREDIT, cn_lost_credit);
+			IBMVFC_TEST_FPIN_EXT_HOST(fs, FPIN_CONGN_CREDIT_STALL, cn_credit_stall);
+			IBMVFC_TEST_FPIN_EXT_HOST(fs, FPIN_CONGN_OVERSUBSCRIPTION,
+						  cn_oversubscription);
+			IBMVFC_TEST_FPIN_EXT_HOST(fs, FPIN_CONGN_DEVICE_SPEC, cn_device_specific);
+			break;
+		case IBMVFC_AE_FPIN_PORT_CONGESTED:
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_CONGN_CLEAR, cn_clear);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_CONGN_LOST_CREDIT, cn_lost_credit);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_CONGN_CREDIT_STALL, cn_credit_stall);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_CONGN_OVERSUBSCRIPTION,
+						    cn_oversubscription);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_CONGN_DEVICE_SPEC, cn_device_specific);
+			break;
+		case IBMVFC_AE_FPIN_PORT_CLEARED:
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_CONGN_CLEAR, cn_clear);
+			break;
+		case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
+			IBMVFC_TEST_FPIN_EXT_HOST(fs, FPIN_CONGN_CLEAR, cn_clear);
+			break;
+		case IBMVFC_AE_FPIN_PORT_DEGRADED:
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_UNKNOWN, li_failure_unknown);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_LINK_FAILURE,
+						    li_link_failure_count);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_LOSS_OF_SYNC,
+						    li_loss_of_sync_count);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_LOSS_OF_SIG,
+						    li_loss_of_signals_count);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_PRIM_SEQ_ERR,
+						    li_prim_seq_err_count);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_INVALID_TX_WD,
+						    li_invalid_tx_word_count);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_INVALID_CRC, li_invalid_crc_count);
+			IBMVFC_TEST_FPIN_EXT_TARGET(fs, FPIN_LI_DEVICE_SPEC, li_device_specific);
+			break;
+		}
+	}
+
+	destroy_workqueue(wq);
+	put_device(&rport->dev);
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+	scsi_host_put(vhost->host);
+}
+
 static struct kunit_case ibmvfc_fpin_test_cases[] = {
 	KUNIT_CASE(ibmvfc_async_fpin_test),
 	KUNIT_CASE(ibmvfc_full_fpin_test),
+	KUNIT_CASE(ibmvfc_extended_fpin_test),
 	{},
 };
 

-- 
2.56.0


