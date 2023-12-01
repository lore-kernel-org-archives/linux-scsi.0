Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GtWJ/wzc"
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D7B1BD3
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:15:16 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6cde11fb647so2217998b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443715; x=1702048515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRvflStZ/vTcP5B8zVnsU2ULybvGH2B1eMnhOvB9jfI=;
        b=GtWJ/wzcoOW5Jc3UDjFMV81ANMdOg5e0pedMcEQBThMVaiJvZeoMKfs8uaoECnZFNx
         orK42lnrM+sIthwFggaw6nUl7gpytq02A5vlbNO/t13babiolophin53U7p4xwymiWfm
         GRbi0RbNy3Z6WeFd4UL9nN6YjqzSNE92cxJ/hcXdRHTifM7L/oYTE/qs8JhEGvv4INbi
         F/XiVrm7fcCwWr2+HkEpY4FdYE0IZKzQAdna0U5OTkSCrbAxdBbhi3Llq42NvstM1JXj
         MgSYEbSGzSpj3RGkBuH4jqSqc7m4ZCie7zJfamt2BQU5JiB0EU0JnYgCXXNtqL0vFxZZ
         CNDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443715; x=1702048515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HRvflStZ/vTcP5B8zVnsU2ULybvGH2B1eMnhOvB9jfI=;
        b=G84tPegDdXW0co9lwhYtfSNQr6QdC7qWuYbqQU4WydsGMYiuTV+g9bgV36n0EONwVq
         9yr7PQpuIJ5QfuNAxsSARvRxXeJZtYStS1tZOkcUlrv4YJSbusyGsRL4C/eymQtAJ/5x
         IPcFMHLShWALME8GtxqujW+/Dq8/UzJemq+diNjiEcr4kf0X1pUvk2+laX1EEHpMfod7
         ZIkL+EeNLBaPvirK+ASd20DZ5NIGvOVTcyjMA9qfBtwNajxraiTfbMDN9MeETGa9EGOj
         OyAIW3Woh43EUSOEKs7qG2KOuagcW/rHJ9wRrjQpCQtz8KNuPJqjlExNj8rQmNDYF/Eg
         darg==
X-Gm-Message-State: AOJu0YwGtNfqYOT3Kd3vva83ou1VwFdxtVOhNp/tJmhTr7A/v5VNWNxv
	GhT+PoELYgCVaO1+oUqkV1k6
X-Google-Smtp-Source: AGHT+IFL+VdkT8Jx4gdpedUqkKxN/i8MfrhTGRszx2lMQkD1Yq8i2V0FL16deBTMgMSjHw0oq7LBQQ==
X-Received: by 2002:a05:6a00:1401:b0:68a:5cf8:dac5 with SMTP id l1-20020a056a00140100b0068a5cf8dac5mr29042906pfu.22.1701443715471;
        Fri, 01 Dec 2023 07:15:15 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:15:15 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: martin.petersen@oracle.com,
	jejb@linux.ibm.com
Cc: andersson@kernel.org,
	konrad.dybcio@linaro.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 12/13] scsi: ufs: qcom: Sort includes alphabetically
Date: Fri,  1 Dec 2023 20:44:16 +0530
Message-Id: <20231201151417.65500-13-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sort includes alphabetically.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 824c006be093..590a2c67cf7d 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -4,26 +4,26 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/time.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/devfreq.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interconnect.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/platform_device.h>
 #include <linux/phy/phy.h>
-#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
 #include <linux/reset-controller.h>
-#include <linux/devfreq.h>
+#include <linux/time.h>
 
 #include <soc/qcom/ice.h>
 
 #include <ufs/ufshcd.h>
-#include "ufshcd-pltfrm.h"
-#include <ufs/unipro.h>
-#include "ufs-qcom.h"
 #include <ufs/ufshci.h>
 #include <ufs/ufs_quirks.h>
+#include <ufs/unipro.h>
+#include "ufshcd-pltfrm.h"
+#include "ufs-qcom.h"
 
 #define MCQ_QCFGPTR_MASK	GENMASK(7, 0)
 #define MCQ_QCFGPTR_UNIT	0x200
-- 
2.25.1

