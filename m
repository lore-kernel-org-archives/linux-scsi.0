Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PxCKx8n3"
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02EB129;
	Sun,  3 Dec 2023 11:33:37 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5d226f51f71so41159657b3.3;
        Sun, 03 Dec 2023 11:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701632014; x=1702236814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mr02jQnghvPlVXTkXMq03CUtxqFWGozfMvZEVXjbV24=;
        b=PxCKx8n3mr7Tnk580mPbfA6DuyfCw4+JhiGxgocEYk/WF+w1/OTXdN1o9CVeAa9roU
         5MIztvN8MSGWx25InfIQDq+4SNa8es62XGIHpMscY/pe2iPaFtc5ci0g3PwFlFDnpBxb
         r/RbSnI7BNqoCjgAhYkxzC0G1zy5zaoOHnOxclslOFjIJuGKw01+hjW5lBv+ige5auRi
         chxyKaor421hkqdNIaj4ZBV7df6tqzyIUjq/LZfgNSgaZ2nhXTO/80OC8zqIC4MdrsIF
         uwua/Td00cMVLYAM0/EAIZ35q4goTTWFwBexKETflU6gz0hqQXANqYBf6C/otidhfOpa
         F5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701632014; x=1702236814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mr02jQnghvPlVXTkXMq03CUtxqFWGozfMvZEVXjbV24=;
        b=hJNvn7mBvS1ZNwuLlK9DMfMybtTzJ+uDHoTVtaVsNDSoInmLHCMfQ3HfDYG2MskCmv
         s3wwkfrTEXpsoEZ7AVLsoLczFiyhxOVXtTug8HsKqJPl63Wt7OI+0pFBnglEOn1985FM
         Ig8IRpVj0fzx0ujzdBS6MszFS8gcNn063zGzo2genUNVEm0hmBNKramXukgaksaesG6U
         7Q/980o/2QDk6DLswQR021u9cyi7A7bR8Snj3ByX5lK8Wc/MFoBM5/9H6gOqhDKybpv1
         zEeypRzXWJjIMBTyVmS07EyQxv5A2b69cwBjJ0j8ivL5NEoetW855ZRvBWxe1y/s9cmt
         9IGw==
X-Gm-Message-State: AOJu0YzwxHaIBvVR9o9f7urLDNTL5CrgsIXq9qgm08R2xNS/VFKB8cOj
	S8VbR/Qf45WlIRBGuuptD7hEyqxALdpliQ==
X-Google-Smtp-Source: AGHT+IEbqmm9rCxeBNlYH2F2vKM++82aNyf5b8oYOzBQ8qa8l9/PZh/0h3fEXihc5rVCTJK2NjjiHw==
X-Received: by 2002:a81:b622:0:b0:5d7:1940:dd63 with SMTP id u34-20020a81b622000000b005d71940dd63mr1863452ywh.57.1701632014299;
        Sun, 03 Dec 2023 11:33:34 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:cb98:c3e:57c:8191])
        by smtp.gmail.com with ESMTPSA id j139-20020a819291000000b005d7f46f6ccdsm700161ywg.23.2023.12.03.11.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 11:33:33 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Matthew Wilcox <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v2 15/35] scsi: core: use atomic find_bit() API where appropriate
Date: Sun,  3 Dec 2023 11:32:47 -0800
Message-Id: <20231203193307.542794-14-yury.norov@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231203193307.542794-1-yury.norov@gmail.com>
References: <20231203192422.539300-1-yury.norov@gmail.com>
 <20231203193307.542794-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A plain loop in scsi_evt_thread() opencodes optimized atomic bit traversing
macro. Switch it to using the dedicated iterator.

CC: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/scsi_lib.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf3864f72093..a4c5c9b4bfc9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2494,14 +2494,13 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 void scsi_evt_thread(struct work_struct *work)
 {
 	struct scsi_device *sdev;
-	enum scsi_device_event evt_type;
+	enum scsi_device_event evt_type = SDEV_EVT_FIRST;
 	LIST_HEAD(event_list);
 
 	sdev = container_of(work, struct scsi_device, event_work);
 
-	for (evt_type = SDEV_EVT_FIRST; evt_type <= SDEV_EVT_LAST; evt_type++)
-		if (test_and_clear_bit(evt_type, sdev->pending_events))
-			sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);
+	for_each_test_and_clear_bit_from(evt_type, sdev->pending_events, SDEV_EVT_LAST + 1)
+		sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);
 
 	while (1) {
 		struct scsi_event *evt;
-- 
2.40.1

