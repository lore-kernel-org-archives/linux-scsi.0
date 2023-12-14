Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F6168EBF
	for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-28b05a2490bso1180328a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 11:24:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702581863; x=1703186663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QzXsKuVexNSFC1SJkZMJaBgpMV5IDYJWlK7e/XpGbjA=;
        b=e7Bf5nQn79vtjk6pyEiVLs8x553i2h4baK59YRxatMFT/Jq3174BmXPTLN4APKgj09
         IKCXeIfKrEgL9UMNImnAA+sFDbo2QVWpK8xCVnuvDNjWQp2Df9I/b33cni8qwd4UqE6V
         1PAOHf0Ona+6DM4wW2ZlriGsLl7FDxfBtUtxzy7YGsm+Qp2Mhikfr7n0+3L9Po8E4qu8
         sGedbkaWE6MRXBIRz1HgKYmAw37diYQU7Pgz0+mNctsAcDkcLfHm/3IUtzZsGwkIU4LB
         DV5qwrdDNm8trhsmPF0G55RgVsj08DP05klA8f6gq5lSba346FANUoclP3ArUZsVyjze
         m4mw==
X-Gm-Message-State: AOJu0YyLwA1Lqg+6dfv4xDr7034Gsd1pRQWI7Ndf7ZnV+Ocz2UjQLbql
	MsP/KpZJIS5hr26CVsD2vtJfDPS5Mdw=
X-Google-Smtp-Source: AGHT+IGk6iFb4BUyR/KoI1aV+X3KL575wIXQKwWaEFhyTkHmBh+GQ37ks7r4C2jtH8ojAD6t2HJG6w==
X-Received: by 2002:a17:90a:3d05:b0:28b:10ae:b67d with SMTP id h5-20020a17090a3d0500b0028b10aeb67dmr842333pjc.7.1702581862550;
        Thu, 14 Dec 2023 11:24:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bae8:452d:2e24:5984])
        by smtp.gmail.com with ESMTPSA id 61-20020a17090a09c300b0028b0d8b3cdfsm1718495pjo.57.2023.12.14.11.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 11:24:21 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Simplify the auto-hibernation configuration code
Date: Thu, 14 Dec 2023 11:23:56 -0800
Message-ID: <20231214192416.3638077-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin,

The two patches in this series simplify the code for configuring
auto-hibernation. Please consider these two patches for the next merge
window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
  scsi: ufs: Simplify ufshcd_auto_hibern8_update()

 drivers/ufs/core/ufshcd.c | 40 +++++++++++++++------------------------
 include/ufs/ufshcd.h      |  1 -
 2 files changed, 15 insertions(+), 26 deletions(-)

