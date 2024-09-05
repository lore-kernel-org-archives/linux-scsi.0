Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE9719D094;
	Thu,  5 Sep 2024 12:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725538839; cv=none; b=LUYk3BUV/HDzTN/o4RLWUoXhzYJUc8GV1aoJREmZeJvpIA6YCEgCvWwM5vO56rbcp7MCAv1hfSA9lHHPkYb3d0k0lAaXEyYs6gscNFd0o0j/xhoy02EZmCsUkNm4JGGvuOoM/8ptb/OghljejtjYpXy8henjYNAaDTSvMgB/blI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725538839; c=relaxed/simple;
	bh=ZmeOlaaOh9kVk2+9NLmZUlpwkAalEB7RSAlNl4Z6j0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YG9NRS+HFKsebtapgWuXuv9aq5iYVf3Av2uXtDPQY5UcRc0LEr+nyuFDUfrbQA5UP1FeelbNT2XJm1dNVD2cGWthOL7ccHzmAXG9UsqylSMQ7LktIUrwpMDZXNa8sEjgwc1nQS4w/gcx6mU02Dg8MEK8LPVUJJNmOsZBkb4A+V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AxxJW/FQ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxxJW/FQ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42bb6d3e260so5863135e9.1;
        Thu, 05 Sep 2024 05:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725538835; x=1726143635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RkF3c4SobrDXf1nxccj+xvHL2kkrQQbHITLvPNDFfQ=;
        b=AxxJW/FQ3xSRcYP7jyaQFNogrhrhgMzTJwlna1aGTCy1Ue9IRMlyQ0w007r01GPK5J
         szYbkCWw77EzHZeiz48DORqDQYibYL5tscmM1qYhzuG53k5JldNNc2CD02TMcb0tkk+p
         NmNAsDR4g1qPK+I9yU/AW6kHJqOSfprJ/bWm5vb/wG+fl/xjNAI/usPd1xTQwHjrXm71
         qVY1EKO4M0lAu5nAJl99fDzrjIBwurjxmjfUPehrRpQHYEF/sZoh29qr6/wMnuzXt67H
         m3LHhHu5ROm8GSKlswEHpB4y128kDsn+qOB56htUdz0YZlQp8LgD5rIH8MkZQK0IgYIS
         yq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725538835; x=1726143635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6RkF3c4SobrDXf1nxccj+xvHL2kkrQQbHITLvPNDFfQ=;
        b=r8SYpWK/947OOTN2fk7Ph3YIqZ9apt2qKUsXCVPClC+Y6j5BQ1rupEOrKvuikx6M5h
         miBmT6Epd5Zs2cYI/PRNDqkSoSuHwBgZZthYoEUcck9gpdqOOZByokXO0w+ZrIFB5m1t
         O3ZPJdwjzL+4TiWBbH93BjQ2bZ4J4tWq/gPmaG7TADVYQkpdSq2YMzU+i8RsCJWysPnr
         B3zqlIKr72QIyHjA0pLGfAd1T5QJBaI3ltn8YdfTUhTdanIdQ8+SGn1PilqWm2mFSG6z
         JjCqapb1pCJfM8vDz6rELJkwLnIY/JRzcrfsSbeWdD6nA5mCq+/cjOCowKWwF7NRFMn1
         +vGA==
X-Forwarded-Encrypted: i=1; AJvYcCUuSvBmfmi/Gdq+T2AcHdtYA0XoEZZJFmRWJLWaWuIRL2XAH042spCOyKx4djjiS4cUERBi6PrUbbob@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf1kRxb93+H40VEUNHtCg43RlOHJyIRCUksVIN+JoBCZvEg93k
	EJ8UDTjgkzzPUZVE+Va4YPn8b13VhrJF794IEzWLEb6wpRr4MLB2ZwEpYiHL8sY=
X-Google-Smtp-Source: AGHT+IFfk2dqKIN6EayJd/vA6vuOatOhuVXuNPc+l466cJU6az9aQ69jL+4z9WvuB+8TJW1bQNPqQQ==
X-Received: by 2002:a05:600c:19c7:b0:428:1ce0:4dfd with SMTP id 5b1f17b1804b1-42be48faa20mr135102675e9.34.1725538834947;
        Thu, 05 Sep 2024 05:20:34 -0700 (PDT)
Received: from fedora.iskraemeco.si ([193.77.86.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6e27364sm230390515e9.34.2024.09.05.05.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 05:20:33 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 07/18] scsi: libfcoe: Include <linux/prandom.h> instead of <linux/random.h>
Date: Thu,  5 Sep 2024 14:17:15 +0200
Message-ID: <20240905122020.872466-8-ubizjak@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905122020.872466-1-ubizjak@gmail.com>
References: <20240905122020.872466-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Usage of pseudo-random functions requires inclusion of
<linux/prandom.h> header instead of <linux/random.h>.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 include/scsi/libfcoe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 3c5899290aed..6616348e59b9 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -15,7 +15,7 @@
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/local_lock.h>
-#include <linux/random.h>
+#include <linux/prandom.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
 #include <scsi/fcoe_sysfs.h>
-- 
2.46.0

