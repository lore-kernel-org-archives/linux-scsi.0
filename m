Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EE318FC8B;
	Wed,  5 Jun 2024 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579069; cv=none; b=Wcdi2bjf8Ppi2OzbYsddV5Nl3yMB+c9xwdDtw0EV6NBxiyHX6JE65oV/UUUvUkgp5ZFg6eBZr6D24ttLdOQ7wXIPitaF+keFfzB94GSAUsNFb8w7eUEkdFKrFkZSFEX8tcnMz4bDIoHEq8ruhSukInR7Wx3v4JyQn1IF8bliWAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579069; c=relaxed/simple;
	bh=FHjszgusd45PxdBvhkAiO3DDpb6AUvLCakPupDn86fg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nTnb9VphaY9RYEt5ctRdLTLjGCUW4dFlJvb4g8zLv5VRAEx2kQ86dw+q/1Qjn/5+PFYAx21rYHuQDoG4t6JQ9ghoUSqvNepJcMdVA2YEwBTczdcW9lsh0tNZ4WdlVohz3/H5TQv46tZc5ArhXy4Vxp1M65pe+hLKhpYKwO0F5t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VGJ71kK6; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGJ71kK6"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f63642ab8aso41116285ad.3;
        Wed, 05 Jun 2024 02:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717579067; x=1718183867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/F5j1VsPlycd0S6aZpefRlptM4yjlekAf0hSgA6m9EA=;
        b=VGJ71kK6aDZrbtmnz76EcE+BE+Fp8DjvnyGJT98r2wccEj02jP4AtCcP6R9vbFU1F2
         ugAcAxEaNAb+kvd1LJVhmj9um6IsFIF6RH1xRPCFi52ynJUlucgis/9MGbczgMyGV2/D
         aA3v2FyqAebXNBI8juTqGDVRA89lFJ7aFYRCIfuX+9Wb4ojGXTRfUm36HR7bxyqmFPGr
         7k4xgW8zNAqFWhjUxJ20v0HDZ0C2LCPy8EPvPOS7hwGZpmij5BnKXLtgZLwB5E76edS6
         UAR/pbEU5mGg6iHmAdnqix0U387EqwlP6LG1F6utXaZXRMGdW5IQq4v+/829GtygMkwX
         hyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717579067; x=1718183867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/F5j1VsPlycd0S6aZpefRlptM4yjlekAf0hSgA6m9EA=;
        b=djnRncAwizW/tSJBlcvSIKf35xjy8Rkegs/1F/zdmfOPQ/Nb8qW9BIPS3FJMrzyKgZ
         IAHvYreqWzkFyHQRsI6CMJtD4TnZ+XcZ4IuUzeJ2NxcmmOxlTRgsixIYiwRaHF+YdEVi
         WHIL5DDi8q6PH5czn3TchezV4hkdnHGC4K33v0UkRHN3R1tLRqWu0vGkPfTCVmtsZxJ5
         f25jUwPoVLeOHaKR0vEuQT4dBlit1F8td4+KDmCYip7QFhMxifph3UUGHLfNktuepGv2
         577t9BnGV3ALb+0vLLMAbHDdC11aVhr4L2fZsqTs8sn9sNDrTDMBwuP8e91DEQP827Dh
         rtkA==
X-Forwarded-Encrypted: i=1; AJvYcCWrYUGJmI4dn8ap1dxtnPxhkwxF0v6X+Akxc49XkFjd+08V36N+95QLf3Ogz21Kfu/NZBI6mpQqcsZDI1rnYNj0/JXJVCHCfQNjanFm3l6aK/zrTVhZJPld96uI6s8okTnGLlf9baumUw==
X-Gm-Message-State: AOJu0YxE0nBv0vk02071ikUYwOs9bzoHuddSl3DhTaASUTwbricxsRXX
	ziIbZMse1HkkX0XuXmLu7XdZC2HcRhZP7uvj03mK01AAefzLCQJ/
X-Google-Smtp-Source: AGHT+IGkGWWqtkgd9ErKwUWCKt04PhbIzbOF+JXhmpepSdkGfgMGWkZaPy+md/106vx2JrvsOMuCjg==
X-Received: by 2002:a17:903:41d1:b0:1f4:7d8b:cd87 with SMTP id d9443c01a7336-1f6a5a7bb03mr24517345ad.67.1717579067378;
        Wed, 05 Jun 2024 02:17:47 -0700 (PDT)
Received: from localhost (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f676917bb2sm55621545ad.230.2024.06.05.02.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 02:17:47 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>
Subject: [PATCH v5 1/3] scsi: core: Add new helper to iterate all devices of host
Date: Wed,  5 Jun 2024 17:17:29 +0800
Message-Id: <20240605091731.3111195-2-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20240605091731.3111195-1-haowenchao22@gmail.com>
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

shost_for_each_device() would skip devices which is in SDEV_CANCEL or
SDEV_DEL state, for some scenarios, we donot want to skip these devices,
so add a new macro shost_for_each_device_include_deleted() to handle it.

Following changes are introduced:

1. Rework scsi_device_get(), add new helper __scsi_device_get() which
   determine if skip deleted scsi_device by parameter "skip_deleted".
2. Add new parameter "skip_deleted" to __scsi_iterate_devices() which
   is used when calling __scsi_device_get()
3. Update shost_for_each_device() to call __scsi_iterate_devices() with
   "skip_deleted" true
4. Add new macro shost_for_each_device_include_deleted() which call
   __scsi_iterate_devices() with "skip_deleted" false

Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
---
 drivers/scsi/scsi.c        | 46 ++++++++++++++++++++++++++------------
 include/scsi/scsi_device.h | 25 ++++++++++++++++++---
 2 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3e0c0381277a..5913de543d93 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -735,20 +735,18 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 	return 0;
 }
 
-/**
- * scsi_device_get  -  get an additional reference to a scsi_device
+/*
+ * __scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
- *
- * Description: Gets a reference to the scsi_device and increments the use count
- * of the underlying LLDD module.  You must hold host_lock of the
- * parent Scsi_Host or already have a reference when calling this.
- *
- * This will fail if a device is deleted or cancelled, or when the LLD module
- * is in the process of being unloaded.
+ * @skip_deleted: when true, would return failed if device is deleted
  */
-int scsi_device_get(struct scsi_device *sdev)
+static int __scsi_device_get(struct scsi_device *sdev, bool skip_deleted)
 {
-	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
+	/*
+	 * if skip_deleted is true and device is in removing, return failed
+	 */
+	if (skip_deleted &&
+	    (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL))
 		goto fail;
 	if (!try_module_get(sdev->host->hostt->module))
 		goto fail;
@@ -761,6 +759,22 @@ int scsi_device_get(struct scsi_device *sdev)
 fail:
 	return -ENXIO;
 }
+
+/**
+ * scsi_device_get  -  get an additional reference to a scsi_device
+ * @sdev:	device to get a reference to
+ *
+ * Description: Gets a reference to the scsi_device and increments the use count
+ * of the underlying LLDD module.  You must hold host_lock of the
+ * parent Scsi_Host or already have a reference when calling this.
+ *
+ * This will fail if a device is deleted or cancelled, or when the LLD module
+ * is in the process of being unloaded.
+ */
+int scsi_device_get(struct scsi_device *sdev)
+{
+	return __scsi_device_get(sdev, 0);
+}
 EXPORT_SYMBOL(scsi_device_get);
 
 /**
@@ -780,9 +794,13 @@ void scsi_device_put(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_device_put);
 
-/* helper for shost_for_each_device, see that for documentation */
+/**
+ * helper for shost_for_each_device, see that for documentation
+ * @skip_deleted: if true, sdev in progress of removing would be skipped
+ */
 struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
-					   struct scsi_device *prev)
+					   struct scsi_device *prev,
+					   bool skip_deleted)
 {
 	struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
 	struct scsi_device *next = NULL;
@@ -792,7 +810,7 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 	while (list->next != &shost->__devices) {
 		next = list_entry(list->next, struct scsi_device, siblings);
 		/* skip devices that we can't get a reference to */
-		if (!scsi_device_get(next))
+		if (!__scsi_device_get(next, skip_deleted))
 			break;
 		next = NULL;
 		list = list->next;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c540f5468eb..5cb294ff0a41 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -412,7 +412,8 @@ extern void __starget_for_each_device(struct scsi_target *, void *,
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
-						  struct scsi_device *);
+						  struct scsi_device *,
+						  bool);
 
 /**
  * shost_for_each_device - iterate over all devices of a host
@@ -422,11 +423,29 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
  * Iterator that returns each device attached to @shost.  This loop
  * takes a reference on each device and releases it at the end.  If
  * you break out of the loop, you must call scsi_device_put(sdev).
+ *
+ * Note: this macro would skip sdev which is in progress of removing
  */
 #define shost_for_each_device(sdev, shost) \
-	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
+	for ((sdev) = __scsi_iterate_devices((shost), NULL, 1); \
+	     (sdev); \
+	     (sdev) = __scsi_iterate_devices((shost), (sdev), 1))
+
+/*
+ * shost_for_each_device_include_deleted- iterate over all devices of a host
+ * @sdev: the &struct scsi_device to use as a cursor
+ * @shost: the &struct scsi_host to iterate over
+ *
+ * Iterator that returns each device attached to @shost.  This loop
+ * takes a reference on each device and releases it at the end.  If
+ * you break out of the loop, you must call scsi_device_put(sdev).
+ *
+ * Note: this macro would include sdev which is in progress of removing
+ */
+#define shost_for_each_device_include_deleted(sdev, shost) \
+	for ((sdev) = __scsi_iterate_devices((shost), NULL, 0); \
 	     (sdev); \
-	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
+	     (sdev) = __scsi_iterate_devices((shost), (sdev), 0))
 
 /**
  * __shost_for_each_device - iterate over all devices of a host (UNLOCKED)
-- 
2.38.1

