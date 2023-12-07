Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHnmMq/e"
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EAE172C
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 14:28:35 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-286e9ce9feaso369473a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 14:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701988114; x=1702592914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=racli9HkpvZjyr/8X6g1Lv7V9dartdnruS6J/RJulU8=;
        b=mHnmMq/eSjf98/GGmg7yeqRm+fUhbGzCoIQl8ZfIbJDBWQZRFCkLOGzEQNa+SacShX
         +ejHxWoW33JOIZgNtfEaI060bpqVGV5O94+zTtlPvLGhZ1ulj12tOgFiXycwglMq2GO6
         yPDBnSw/xLgZ1Ouv0a2xf0qygDkfL9rwjJ/Jp7IDuv9ln7q22KHxl5op/1fXnEWQAwTD
         En4zPavXMMsxtzC//Du9yNeZTbfaoIeCPHkkebuLx8lX5ixc57acFqKxpqh7kzC80SXx
         ZWMcuxe0jdwBX0V28Lj6CkEmbuqtYs/JhMbKjvlqutJSbswWAiqSdAcnXQgilaMJoAXx
         quLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701988114; x=1702592914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=racli9HkpvZjyr/8X6g1Lv7V9dartdnruS6J/RJulU8=;
        b=ml8HT1mLWasEH4o0WJHmYxP+7E1cyRlFrrnQbCjrELD66aMj/3jhcJEmWP0sXux0D1
         C00vp+QgNaSm2tYOKVFrsaM2N6dULPjVsRivGxLykJSuf+OPRASdSHe/3aXf5HjLaih/
         vyttd5KQuR/qe6SXp+R52orEBDDuEUt1X9MXhqgCBbZWlfkSyncU/58Ivawe9L4DQDXO
         AbVxLuvskGKNWtgCW3HlUPskHrxaf3crwNo+d7enz93U5EGtCn/eyGVMCj4laJUEZzjH
         B22+1bREVCjyKyW9EAZCKP5ASq0HnetS6V9cI87q25vJWsbw9KXCXL1Q5p6rEGv9+8VF
         GUmg==
X-Gm-Message-State: AOJu0YyzaZmFIZGt+EdPCCZ5lmqHVVrLeO8gQIodKxJQPIujbaEYtqA9
	0ebEVk0Tf6uhi8Vkuurwq3DOD9pBuhEyrA==
X-Google-Smtp-Source: AGHT+IEFsshXm8kLOu8nljplDyfno0SzgrQ7GMogun1Xaumlm3yTDnKyOEKuVue1Ej6/RY+k2TFaUw==
X-Received: by 2002:a17:90a:5908:b0:286:515e:b8e6 with SMTP id k8-20020a17090a590800b00286515eb8e6mr6402927pji.1.1701988114554;
        Thu, 07 Dec 2023 14:28:34 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902c3d200b001cc3a6813f8sm312417plj.154.2023.12.07.14.28.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Dec 2023 14:28:34 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/4] lpfc: Update lpfc version to 14.2.0.17
Date: Thu,  7 Dec 2023 14:40:39 -0800
Message-Id: <20231207224039.35466-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231207224039.35466-1-justintee8345@gmail.com>
References: <20231207224039.35466-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.2.0.17

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index b7d39e2f19fc..aba1c1cee8c4 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.16"
+#define LPFC_DRIVER_VERSION "14.2.0.17"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

