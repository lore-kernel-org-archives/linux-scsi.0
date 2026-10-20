Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.37.86.79
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792530063;
	b=hW1O8mPPr6Yabskrp6lEeDyjLvXjc2CFd55wxyAIbIdlO6ZodSVK09hDVHD2OmNMe3t/
	 aVr0EkQlAJvi0vg9BzQg7TvQvSq2rJyoXdv1nvCDR+KFUw5TAeYF3KlF/o7UTJtMQAO5O
	 rHHRqyrS/kft7Y761n3eUFNkx9Wj4Q5gzt9tJ/FG8A63SEA8jSRtML8D6Q3h+jdVYWGJN
	 VP7f+wEFVbrSe6d8aTfSw0xWl9SDcoa6sWbifDEsPu8bmaLbIIpIFVhkMxJzby3mtavqU
	 MfxuiFcWzO9OzaiiCyg0n7iItERcwt35iLq0/pWGDtrbGm4ffgZSM2wacUrdkx/WGSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530063;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IPAS-Result:IronPort-Data:IronPort-HdrOrdr:X-Talos-CUID:
	 X-Talos-MUID:X-IronPort-Anti-Spam-Filtered:X-IronPort-AV:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Authenticated-User:X-Outbound-Client-TLS:
	 X-Outbound-SMTP-Client:X-Outbound-Node;
	bh=sStWA3eP+fg4gqdrzt9l/SH3csz8qYH2NP7P6WSTMOc=;
	b=ZoGxQ1ZjeOQxiyrrTsyv9QZRBFYRA24bT2cX43J8KVEn7ZFWGZgmcWNgcPzYvNTLz20K
	 J8Xq8lQJj/+P0nYuyjnb+Y+DSOB+vizBGdC+qE5VLZO6HJn0zscKQ128EV5NQOY6SFQZN
	 xPS9ZH/6AF4wy7LCdoj1O5I4ZJ1R+WGMPgW4wnfWxNgWRHGzbgKOX5ny0p0at478QyVeI
	 myfdlfQBZbEoehKn4+Z0wgJRjjqLT1/a5QjmyDkjl1Ym+CUWra197rPBjC+f3inhqAT5a
	 G8OrBHGzdaG2XVUKmYMjJXXamSwOYXaNi7vGtA49LlfZhc88BP3pJhlOQoBk23DXoSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cisco.com;
	spf=pass smtp.mailfrom=cisco.com;
	dkim=pass header.d=cisco.com header.i=@cisco.com header.a=rsa-sha256 header.s=iport01 header.b=Z9HMaAQc;
	arc=none smtp.remote-ip=173.37.86.79
Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809A5606A325;
	Tue, 20 Oct 2026 21:01:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 809A5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cisco.com header.i=@cisco.com header.a=rsa-sha256 header.s=iport01 header.b=Z9HMaAQc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1738; q=dns/txt;
  s=iport01; t=1792530062; x=1793739662;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sStWA3eP+fg4gqdrzt9l/SH3csz8qYH2NP7P6WSTMOc=;
  b=Z9HMaAQc3nS5bn4rIeZjH3+f+GMsW3FbmOKRicfuMQCeDX/cGPek66k6
   DfmAefKmzI/jhGi1+eOu1iAD7LObq6iwIe3/+rJfwJ0x+79NjBiowcdJT
   KLGP9aosFBS2kobbFMJiN52MHZ47DiGazd+TY2SLk15XEUdQVn6NqiLKn
   s+wskkt1iPjeVFKzUdhbv+nYI2QgGIxhCWh2jjYRRoFdyZNEhcjGfFEq4
   3BC+GeLWqMowchHeWKBoTBqQdDzSnapDHoiEQyiKXz7Pa7+GO3efE/qs7
   CsvyyiUWHRDmqz0lXKLDOKOKwiRclnrCNIWczKv8ip/kwFcvegNnQZl8b
   A==;
X-CSE-ConnectionGUID: dNcoE7x4SYaZ4JIq6ErBFw==
X-CSE-MsgGUID: 8HTA1mCuSNONMj+iDvOkpQ==
X-IPAS-Result: =?us-ascii?q?A0A/AgCY1ddq/5D/Ja1aglmCV4FVQxkwlCqgQIF+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQWOFwImNAkOAQIEAwIDAQEBAQEBAQEBAQEBCgEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXJAVNgFGMIEggwKCdQO1TIIsgQHeSIFoAQsUAYE4hUCII22FBScVBoFJR?=
 =?us-ascii?q?IEVg2mBUoM+hXgEgiKBDIJdk2hIgR4DWSwBVRMNCgsHBYFoAzUSKhVuMh2BI?=
 =?us-ascii?q?z4XgQcbBgWBHYEggRkjGTZrgQldgSspYAEhgQiCAgKCUYIAAgFJQQ4HRVMJF?=
 =?us-ascii?q?g9DEkcmIggSCQETGi4LgRo4PAkoQRUMZwkDGgVEAiIIAg0JB4EBFBgNSBEsN?=
 =?us-ascii?q?xUZBD5uB5FcgweBD4I/pg6hD4QooVwaM4QEpmoBmQiCWaZqgWg8gVkzGggbF?=
 =?us-ascii?q?TuCZ1MZD985JzI9AgcCBw4DC5NmAQE?=
IronPort-Data: A9a23:KNwgWa2VWxm73o17GfbD5TVwkn2cJEfYwER7XKvMYLTBsI5bpzIEx
 2VMUDrXO/yIZTH3f9lzbYSxpxwFuZXTyIVgHgpr3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yEzmE4Ej9atANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX5
 rsen+WFYAX7gmYtYzpEg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGAGc9OqBH6rpMMGh8q
 d45MW4gdDqtmLfjqF67YrEEasULNsLnOsYb/3pn1zycValgSpHYSKKM7thdtNsyrpkRRrCFO
 IxDNGcpNUicC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OW3YYuNJYzTH625mG7Ih
 l7vpmHSHyo8E/q6y3mE3myLhff2yHaTtIU6UefQGuRRqF+exGY7DBwQSEv9oPO8zEW5Xrp3L
 kUO5iso67A/6EGxVdT7dxqiqXWAs1gXXN84O+Q24QKK0q3JyxyUCmgNUnhKb9lOnM0zSDon2
 V+It8nkCTxmrPueTnf13q2Zsz6oIgAPIGMCbDNCRgwAi/HnrJw1hRvJZs1+C6PzhdrwcRn0w
 jaXvG09iq8VgMojyaq25xbEjiiqq5yPSRQ6ji3TX2S4/kZib5WkT5Kn5EKd7vtaKoudCF6bs
 xA5d9O29usCC9SJ0SeKWuhIRO7v7PeeOzqaillqd3U8ywmQF7eYVdg4yFlDyI1Ba67opReBj
 JfvhD5s
IronPort-HdrOrdr: A9a23:AMgzA6DTDrvP/bvlHely55DYdb4zR+YMi2TDGXocdfUzSL37qy
 nAppomPHPP4gr5O0tQ+uxoWpPgfZq0z/ccirX5Vo3MYOCJggaVBbAnxZf+wjHmBi31/vNQ2O
 NdaaRkYeeAaGSS9fyb3CCIV/A93dKA7Kekwc3az3trUEVWTpsI1XYcNu5eeXcGIjWvwvECZf
 2h2vY=
X-Talos-CUID: 9a23:6eJz+WxuvCPAVWfR/NVyBgUYPMsiXyLNkEzhKn3kK0dwFpCPY3GPrfY=
X-Talos-MUID: 9a23:3V4gVws0lLV/96j5T82n1BFeHZ5tyLmVLmcrtJdFuuWaEi9oAmLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.27,168,1787011200"; 
   d="scan'208";a="529907812"
Received: from rcdn-l-core-07.cisco.com ([173.37.255.144])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 20 Oct 2026 21:00:56 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.123.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-07.cisco.com (Postfix) with ESMTPSA id 94E0C18000231;
	Tue, 20 Oct 2026 21:00:54 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com,
	"Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: Update module authors
Date: Tue, 20 Oct 2026 14:00:43 -0700
Message-ID: <20261020210043.5279-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
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
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.123.254];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.123.254, [10.188.123.254]
X-Outbound-Node: rcdn-l-core-07.cisco.com

From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>

Update the FNIC module author list and bump the driver version
to 1.9.0.2.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h      | 2 +-
 drivers/scsi/fnic/fnic_main.c | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 3ba1592940ca..bc63cd7cc495 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -31,7 +31,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.9.0.1"
+#define DRV_VERSION             "1.9.0.2"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index f13c381a66d7..a19c0b0d812d 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -56,8 +56,11 @@ static const struct pci_device_id fnic_id_table[] = {
 };
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-MODULE_AUTHOR("Abhijeet Joglekar <abjoglek@cisco.com>, "
-	      "Joseph R. Eykholt <jeykholt@cisco.com>");
+MODULE_AUTHOR("Karan Tilak Kumar <kartilak@cisco.com>");
+MODULE_AUTHOR("Arun Easi <aeasi@cisco.com>");
+MODULE_AUTHOR("Gian Carlo Boffa <gcboffa@cisco.com>");
+MODULE_AUTHOR("Arulprabhu Ponnusamy <arulponn@cisco.com>");
+MODULE_AUTHOR("Sesidhar Baddela <sebaddel@cisco.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, fnic_id_table);
-- 
2.47.1

