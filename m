Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4153209;
	Tue, 25 Feb 2025 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520277; cv=none; b=c52XDzXL4qdBgYYNqejzLmnpr3o4F8H6SIcgm6reHdsPAKusz0naPD/S0Msvq1aeFWGmCea1YSbDW4WzdwiECafUvimSKe0taRk5vSYM/Wr9+1dTH9KuUhGhP85lXDBJHVbTV5R4hOjrq4MV7i6T8XDD0a8389tLUjEO/co6+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520277; c=relaxed/simple;
	bh=rftS8tH4GM8YtYSmzprWQQW5nTRrqbX2Fg2SKGmK3TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QFJ4vkwAEhJxUsT6t+hn50H6663lUZuJFBi/bCk5DEQLEhTGjwwJnU0Q881vokoQll31tYSZhZWndck0hkw/fxnKfLUpktJxVjyv40u8Dy1lFZuoAV3xvmoI6mvw57AY2ZNE78o+e6cmakEa1r/mjtxD27DkkjeK9hnE/1V2DQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=HQJEwcnL; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="HQJEwcnL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1237; q=dns/txt;
  s=iport01; t=1740520275; x=1741729875;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iyfNPZTyuYPKmgazSumm4YcuvxbstpbUvFtUrHQS5/g=;
  b=HQJEwcnLmBiouVqZKfneNgSkkXeSSubZi7bkbvdAVq37aMddGHc0yzGL
   Ee2i90Zf16oBHV1Pnogj/sn2x4w3lWu+bEx5a9NyCCQ02a1SQYzmqNIY2
   F9fMygsi+OOQ1Sqt6RfiT8g05xtZzehYo+ksUqJ52eCqZ8DBkRYJBC7Iq
   GJTg+Dl+rg8ShEgZqnGVj7oL8uXK8isgRqr5LXeM2z9sAZ1i6BpaIYBZB
   BPrTb/9RLgFESGHyByxVBLR7qfXZhw2Kf+HHGOqYDuTNY6odks5qpRdoY
   568gzG/zNC6Wm+XyobGulf6RfmCjHcOkbwSiUPwzvf56kkBTwVDhf3FWR
   g==;
X-CSE-ConnectionGUID: Pjii2pvwSMG6mbCHjdoPvQ==
X-CSE-MsgGUID: vau5NgW/Qn+XKvqiWnSCxw==
X-IPAS-Result: =?us-ascii?q?A0AnAACsOr5n/5H/Ja1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?wcBAQsBgkqBT0MZL4xyp2qBJQNWDwEBAQ9EBAEBhQeLEwImNAkOAQIEAQEBA?=
 =?us-ascii?q?QMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZdKwsBRoFQgwKCZQOvL?=
 =?us-ascii?q?IF5M4EB3jSBboFIAY1KhWcnFQaBSUSEDm+BUoM+hXcEh1unakiBIQNZLAFVE?=
 =?us-ascii?q?w0KCwcFgXEDNQwLLhWBRnqCRWlJOgINAjWCHnyCK4RUhEOEQYVSghGLPYQKQ?=
 =?us-ascii?q?AMLGA1IESw3FBsGPm4HoCs8hDyBDhSCFRcpOqURoQSEJaFIGjOqVAGYfakwg?=
 =?us-ascii?q?Wc8gVkzGggbFYMiUhkPji0Wz0YlMjwCBwsBAQMJkWUBAQ?=
IronPort-Data: A9a23:/8GW166miuRcX8Qnbb/SaAxRtBPGchMFZxGqfqrLsTDasY5as4F+v
 jdNWT+HP/bYYmDzKNp/PNi1o0NTucXTxt9mHAtu+y81Zn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH1dOC89RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr+KUzBHf/g2QpajhOtvrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eBY8Z+7xvH3510
 NNGLTomThKPgNqo+efuIgVsrpxLwMjDJogTvDRkiDreF/tjGcCFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkESUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIGPJ4XSGJUMwS50o
 ErY9nmkJB4lc+WZigqm7Gutuen0tjPkDdd6+LqQs6QCbEeo7mAaDlsdXEGjrP+lh1SWX9NZI
 lYTvC00osAa9kGpRPH5XhulsDiFtBtaUN1Ve8U/4RuRy6yS+wuFC3IfQzhpb8Yvv8s7Azct0
 zehm9LvGCwqs7CPT3+Z3qmboCn0OiUPK2IGIygeQmMt59jlvZF2lRnUT/59H6OvyN74Azf9x
 3aNtidWulkIpdQA26P++RXMhCih48CZCAU0/Q7QGGmi62uVebKYWmBh0nCDhd4oEWpTZgDpU
 KQs8yRG0N0zMA==
IronPort-HdrOrdr: A9a23:rnZq7qlxAb8t1/Q405YEpoEBmcLpDfIf3DAbv31ZSRFFG/FwWf
 rDoB19726XtN9/Yh8dcLy7UpVoIkmslqKdg7NxAV7KZmCP01dAR7sM0WKN+VDdMhy73vJB1K
 tmbqh1AMD9ABxHl8rgiTPIdurIuOPmzEht7t2uqEuEimpRGsVd0zs=
X-Talos-CUID: 9a23:dVssB2BFCMiELHP6ExFl9U9OAt46SVjyknLaCG+6BWFRVoTAHA==
X-Talos-MUID: 9a23:BXpe6wX7AUSVqaTq/CHlmWxEO/gv2qLtOGMTiJQ5vfKvJTMlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.13,314,1732579200"; 
   d="scan'208";a="325105817"
Received: from rcdn-l-core-08.cisco.com ([173.37.255.145])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 25 Feb 2025 21:51:06 +0000
Received: from fedora.cisco.com (unknown [10.188.0.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-08.cisco.com (Postfix) with ESMTPSA id 61649180001ED;
	Tue, 25 Feb 2025 21:51:05 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] scsi: fnic: Replace use of sizeof with standard usage
Date: Tue, 25 Feb 2025 13:50:56 -0800
Message-ID: <20250225215056.4899-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.0.187, [10.188.0.187]
X-Outbound-Node: rcdn-l-core-08.cisco.com

Remove cast and replace use of sizeof(struct) with standard usage of
sizeof.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index ff9ba7cafc01..3a41e92d5fd6 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -318,8 +318,7 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 			"Schedule oxid free. oxid idx: %d\n", idx);
 
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		reclaim_entry = (struct reclaim_entry_s *)
-						kzalloc(sizeof(struct reclaim_entry_s), GFP_KERNEL);
+		reclaim_entry = kzalloc(sizeof(*reclaim_entry), GFP_KERNEL);
 		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 		if (!reclaim_entry) {
-- 
2.47.1

