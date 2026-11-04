Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794183;
	b=reSywxxTZOPX+PV3zlS55iwi/tRn2JA0S4AW1qzpf+/qcnag7co8Z0Qc8t38vi91lRg6
	 VJPIZgnDf5NPfUv7vBp8yU0CqhEp6vqP6UyQwHzMm3pRkA5mgmTC0Z97t/IFu70roEubE
	 WGgW69oe8JnOY8ZhS1NBAGfIpPdzCijXNXPAmle5C2TOWep9ceKl0OMCO9Au9xoj0I4eW
	 OJg65qQ68ud4JLb2cKhQzGPQiY1Irayy91MJcA4YOjeHu2KZG0QVcSoMnCR317eovAUXn
	 W65x4UTeS5wMXegPgzzR57W7dDz/ZA3Z5ovngsdtz98bvBuyt4GPrz5K03xr4MWM0CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794183;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=LEdQ2O2UslbFAAGqBapedl7P6WrVICkbICX75vfNAfI=;
	b=D+H7ia09UT7educMJin9g+gDLAZ/thdoOWPbpil2Ur84V3R4JugegeZMYh4HfI9JdqQx
	 U6EZrF+OonVHELDM6hDetxLleVBx3n4W3Ui3W61DD5swT1/VQ4FSgCqz7loBMOF0OHdcf
	 RqiSnZNRK0i1hivZ2GnS2GXWWkvHdE0zcomPfIXRZ7KPxP4gPhxByNiS8mvUC+MtWQjIc
	 1Kp2s9dDa0/AMxZlwlT8/nU+ZuLEN7O3bxj1OP/ap4TF2alcg6ZDc41iuCaJZI80LPz9p
	 2haF/xxzU9O0JAFor76cBDh7bGvx6DgfX0Jlz6brHq1XGlfRJrrpLk1NpDLpkfIGp2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=iIryjkj5;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5CD606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:09:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D5CD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=iIryjkj5
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso294810a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794182; x=1794398982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LEdQ2O2UslbFAAGqBapedl7P6WrVICkbICX75vfNAfI=;
        b=Sf9vDR17++R/On33BoAimBpo+lgjT1rWDi+XtljC+JoImB5DOa23b+WlxgBJWzdpCc
         kSFBXPhlhT0R0BdhVHdxEAK3c+5O5v1uvP2M6Ubt+agiYUQRx7nWx0lsP3rN8+4Zagfg
         OFJ9Bvb+vp4bvyNG4EglEldyEuTGg4wCW1TLTT5YWCKt81+VbbgcLuk1m+na67+FM46I
         FrQM3cJxvK4cRTJWXhwl2Bm/Nuo1r5bcOzf8SdpisKR68Xa4NlNX93Mn71wyoSKLZb/f
         fiGcNcGVsI7OeW3RH0g0pwopOhQ5qdNxEoUSURP5L7zSIsCeZ4qF8eUhunewVwkkuj26
         fOYQ==
X-Gm-Message-State: APuU4Z90Gu3osqvJFJU6No+rrJLKGbc5nkIKbX0orVLOKlyVZmelmCsC
	s5aa9qufCu4vWqkbxPDVTMewQKA3eCGcPauz9eoVbJjaDCjy47ZwbvSqf8voITQuJB50nBoX1WB
	mHfRiIjFkWJsygp/nYWcQsFFBF0ut5j3VYek38NuV8Gga/NxDwlNYnqYbwrJxW9gG+nYo/jkLIO
	EnbkiU4i8I2KkVwvJzkGcvyRW3/L3C4z3Zu7g1RvcNbqKHBmL+STgoRcpWfXDzX12NIMjBShEd3
	5GY9Kcn0zLO02UD
X-Gm-Gg: AYBFou1R+tRzBtug8wkdQcvkn+Uoc6NNxTA3RxJGlcoGPmgL3yWz3QRWzPrVLoIc9LA
	dalUE35md9phGhn5RiPpNi17kcevXZxkW85POLPCTjr0eUfez+bhoTyM8XMokDax9wOpT7NFRPW
	GUxkF4UzD7LhW6kxuLX/PbK4QAwdli/MUbEheHQMQj7j+YEG8I8YfscPeSjdmianyvHxIIA5wSV
	qM3pczjg1qWvPwhjcRQ9wSdvtLbXJjY8xQur3/UQoqSVSBcjwPBTqgrfsy2g5YdeRi0dyPBy/J4
	vqW8wyu9CvM/cPa/dZ//t+UO01jdMa4avTlt6QUN3tq7Tm4xddyuCBq+Fpr3P4A15HMcwhnZrKn
	J6mG+PqDhMcf6v1evVn9JgAme9zyDn5Gg6+nr3CQELxP58spRXgzaY9B+9LP1xQQ8r7GUKhgUgk
	XSuq/pYpmyjSNOFPXmDMJFp8TyEJgzrhVOeV8=
X-Received: by 2002:a05:6a21:e089:b0:3e2:b0ce:a7e5 with SMTP id adf61e73a8af0-3e928d6d0b8mr14753071637.44.1793794181604;
        Wed, 04 Nov 2026 04:09:41 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cdb461c29b4sm46271a12.0.2026.11.04.04.09.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:09:41 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-139b62317d0so495799c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794180; x=1794398980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LEdQ2O2UslbFAAGqBapedl7P6WrVICkbICX75vfNAfI=;
        b=iIryjkj5c2vhtzKS24PTGTQLzZggNgagKsouoi2vccyNy6MBU+QAyZaCDulOJw7EjB
         DUIB5YaA2oONdWKaGqDpQldjbZ8Bb/6Tga1MLcPuSaC98PGXq/OCxaY54xy2Yqaovadw
         iXBiLgTx1qIp2/CX/LAcHtiS2CUey7lCPE7mE=
X-Received: by 2002:a05:7022:ea46:20b0:143:5266:48ee with SMTP id a92af1059eb24-1ac5ecb4ad3mr26516869c88.42.1793794179600;
        Wed, 04 Nov 2026 04:09:39 -0800 (PST)
X-Received: by 2002:a05:7022:ea46:20b0:143:5266:48ee with SMTP id a92af1059eb24-1ac5ecb4ad3mr26516779c88.42.1793794178724;
        Wed, 04 Nov 2026 04:09:38 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:09:37 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH 00/21] scsi: mpi3mr: Fix issues reported by Sashiko
Date: Wed,  4 Nov 2026 17:30:41 +0530
Message-ID: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series fixes a number of issues in the mpi3mr driver that were
reported by Sashiko in its reviews of recent mpi3mr patches.

The patches cover the following areas:

 - BSG request validation: the request length, integer wrap in the buffer
   entry lengths, redundant checks and the leak of the NVMe PRP list
 - Admin reply reposting, endianness of device handles and integer
   overflows in the HDB upload and log data size checks
 - The DEVICE_INFO_CHANGED event, target device reference leaks, the phy
   mask shifts and the all targets query
 - BSG use after free fixes, log data size and locking, and the byte
   order of the NVMe passthrough, the status reply and the diag buffer
   post request

Later patches build on earlier ones, so please apply the series in order.

Ranjan Kumar (21):
  scsi: mpi3mr: Fix out-of-bounds read of the BSG request
  scsi: mpi3mr: Fix integer wrap in BSG buffer entry lengths
  scsi: mpi3mr: Remove redundant BSG buffer length checks
  scsi: mpi3mr: Fix PRP list leak in BSG passthrough
  scsi: mpi3mr: Fix reposting of invalid reply address on the admin
    queue
  scsi: mpi3mr: Fix endianness of device handles in BSG requests
  scsi: mpi3mr: Fix integer overflow in the HDB upload bounds check
  scsi: mpi3mr: Fix integer overflow in the log data size calculation
  scsi: mpi3mr: Queue DEVICE_INFO_CHANGED events to the bottom half
    again
  scsi: mpi3mr: Fix target device reference leaks
  scsi: mpi3mr: Fix the 32 bit shift when building the phy mask
  scsi: mpi3mr: Fix empty device list race in the all targets query
  scsi: mpi3mr: Fix the lowest phy number for phys 32 and above
  scsi: mpi3mr: Fix target private data use after free in BSG
    passthrough
  scsi: mpi3mr: Fix block_io accounting when a target is re-created
    during BSG
  scsi: mpi3mr: Fix sense buffer use after free on BSG command
    completion
  scsi: mpi3mr: Reject a too small reply size when enabling log data
  scsi: mpi3mr: Fix partly written and lost entries in the log data
    buffer
  scsi: mpi3mr: Fix byte order handling in the NVMe passthrough commands
  scsi: mpi3mr: Fix byte order of the BSG status reply
  scsi: mpi3mr: Use the correct conversion for the diag buffer post
    request

 drivers/scsi/mpi3mr/mpi3mr.h           |   8 +
 drivers/scsi/mpi3mr/mpi3mr_app.c       | 250 +++++++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |  20 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  83 +++++++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  34 ++--
 5 files changed, 301 insertions(+), 94 deletions(-)


-- 
2.47.3

