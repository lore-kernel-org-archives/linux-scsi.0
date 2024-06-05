Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481784964E;
	Wed,  5 Jun 2024 09:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579066; cv=none; b=jgiR9fEW5zf7ccQf2Wb+cdtnYNdaSG/SmZKjFZ3Hl3ka38sC4jfZOgyctAbhANOdMZmA4VBRjw9y4Mk5txFhNvLHi3uSbr0Zo1BaZc35oGq40i7PjA+z1Vqvkglkv0OliKCASi5MwVINK8gIQHU9cDT0c8ymeppJEStk2Ibon6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579066; c=relaxed/simple;
	bh=PU6m0pSHzHGLq4gKdEbX8+DVVZnKULHa9UHI6U+QVSM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X9EZGIqB+IuXB1fJ9/Z8xysdM/ElCrje4sqxRx+Fmyx7APg9SWPiPTXdHp/fa1VR/a88Kf+sHhQ1RdTyR673jyv48X+pUVndKCjsKqFfAJqIYnZ4DUJsF/LY/YYaikyiRbzGMMxMvy4mI7vzJb4CR7XzxpzOyTlXQ5qZLrlSytQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DQcj3MRR; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQcj3MRR"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70260814b2dso617738b3a.1;
        Wed, 05 Jun 2024 02:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717579064; x=1718183864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GuwzdCEVGaS5YtEbYns0GyeXQN2BoaVJnopmHYaxA2c=;
        b=DQcj3MRRdAMDVdiPWVvIx68mO/RoeZ1sFsGWT2qjL/Fc+tT3a2C/TawqcOVivuwFFt
         r+1vvLK4eK8z9Wo3hfp2aTvvKtl2eFOk5NXl47dEUB25CR3BrBGqxc+Eve18tUbhai0f
         l+UGTIyn16udqm6+2a27c8/4QapograqDfDgEs7DQT2hoSC8HTBxwC7OGCjfUN4hu6QJ
         iNxTxPtu0oL4sYtwZ1jjWac+aDFZdkwy3T/qexCD0pK/i+aiP3VJ8nvKr/EUNdjXM8YN
         LtYvMfOt6AEmcimwphbT/I9YQgTi3WO/z5SXtZqR0VTI86ZgVy7f4UUhI8rCkS8x/nFK
         FjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717579064; x=1718183864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GuwzdCEVGaS5YtEbYns0GyeXQN2BoaVJnopmHYaxA2c=;
        b=MKFrzT24WOTuX6r94IRtqWtZ2X3qgQ3F+O8lI1sgN6VhmKKhm27AzOxmhSe/099Ae/
         gUNwZ39wsg52YqgL0EF1naJpaMRwNPQKQSmT013jXSt1Kdm24khLx3iHr1Uq/aqBKaPg
         h3ILjNKOu6LRpcglS/HowjoeimSfFDdcb3vqjinm+xJGksfUKdD33GVVpIwQooAw9Kvk
         JE/q+ASwzqLRhNLJdfyZgZ0xLsVM5l2osoMdEz3B7gnSuKbmeSlfcKaf5mzlhF9j5ARf
         6xkXGVgo/qQcIM1c2pbWX1a7Sq04pezpU7uBXtUU88NxGIHn3tHL7CWjiTiCarS83+Xv
         kH9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVEAfxzgtIym2wlHRt7CMpEWogHrgJb1senVw+zMUNJfn1fKwnntdisxWy1OiifnmAtq0HlPqe4boq6ZltBSLOQKFo72Q5k3BuA5JK9vVPha6TzFTfEhavq0fBXQUYKNBuuhV3J2fHhPw==
X-Gm-Message-State: AOJu0YxBmQn7l/vsK/lqkqmQG1OFYBLSMeRsL9KHLmklz18hcSyiDnyH
	DarkE3Xsl9GIROqH5y2AU8+ufsrb2pssn27/hCVV1Vfy+ddV1nOb
X-Google-Smtp-Source: AGHT+IG3pdjVlxVCHMn5Xg6OUX9TENjuKkLRhUUX71bHoVxQvED9KvYbPmbyhpvhSgLS55xlOzRiug==
X-Received: by 2002:a05:6a20:7f9a:b0:1af:9161:4048 with SMTP id adf61e73a8af0-1b2a2b61036mr8125888637.1.1717579064455;
        Wed, 05 Jun 2024 02:17:44 -0700 (PDT)
Received: from localhost (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6d9d5af8cdasm708952a12.68.2024.06.05.02.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 02:17:43 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>
Subject: [PATCH v5 0/3] SCSI: Fix issues between removing device and error handle
Date: Wed,  5 Jun 2024 17:17:28 +0800
Message-Id: <20240605091731.3111195-1-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

2 issues are triggered because devices in removing would be skipped
when calling shost_for_each_device(), these issues are mainly in error
recovery path, which are:

1. statistic info printed at beginning of scsi_error_handler is wrong;
2. device reset is not triggered. drivers like smartpqi only implement
   eh_device_reset_handler, if device reset is skipped, the commands
   which had been sent to firmware or devices hardware are not cleared.
   The error handle would flush all these commands in scsi_unjam_host().
   When the commands are finished by hardware, use after free issue is
   triggered.
   The issue first happened with smartpqi devices, and can be reproduced
   with scsi_debug. I did not see any description about SDEV_DEL state
   can not perform device, so this is should be addressed.

A new macro shost_for_each_device_include_deleted() is added to address
these issues. The newly added macro would not skip scsi_device which is
in removing when iterate host's scsi_device and is called when statistic
host's error info and trying to reset scsi_device in error recovery path.

V5:
 - Rewrite cover letter and add fixes tag to each patch

V4:
 - Remove the forth patch which fix IO hang when device removing
   becaust the issue is fixed by commit '6df0e077d76bd (scsi: core:
   Kick the requeue list after inserting when flushing)'

V3:
  - Update patch description
  - Update comments of functions added

V2:
  - Fix IO hang by run all devices' queue after error handler
  - Do not modify shost_for_each_device() directly but add a new
    helper to iterate devices but do not skip devices in removing

Wenchao Hao (3):
  scsi: core: Add new helper to iterate all devices of host
  scsi: scsi_error: Fix wrong statistic when print error info
  scsi: scsi_error: Fix device reset is not triggered

 drivers/scsi/scsi.c        | 46 ++++++++++++++++++++++++++------------
 drivers/scsi/scsi_error.c  |  4 ++--
 include/scsi/scsi_device.h | 25 ++++++++++++++++++---
 3 files changed, 56 insertions(+), 19 deletions(-)

-- 
2.38.1

