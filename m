Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gw2B8i2Z"
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B64BE8;
	Mon, 11 Dec 2023 18:28:17 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 3f1490d57ef6-db53f8cf4afso4217026276.3;
        Mon, 11 Dec 2023 18:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702348096; x=1702952896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CKJG0QWFDRGpjAibRGhHIP11SM03HdEpZd2mC7AZ0Q=;
        b=Gw2B8i2ZDxUP+oP5D9HXJGW9mgoGNCdB+aBNZImdcfGR+Z4vuS0rjdz0qOy8bIQv3A
         l6zfgaua0++Bj6lkn6d0/Fklf11Aq891lJKqooLWpqdIlD4R2dMLHVQvmdP/eRfJyJo9
         3hnqkth/I5gJo4hr9hX0T8f13KqkWEgvQ+CPJXfFolekk7IQSx0UjGFbTtUD2fe9WqaE
         LLq+vSs03pTIfwxsrFxw77/En5DP6OGVX9n3ZIp3Acj7wmP7TC9wyEMSs3wphJRH0tQU
         UsuESDbXyD68iRepKKzgIXYIW1xi9CHV28qMl6+LnMfx0V6c+j6031AK2EOWjPA+HwEm
         0zVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702348096; x=1702952896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4CKJG0QWFDRGpjAibRGhHIP11SM03HdEpZd2mC7AZ0Q=;
        b=OletdryjyntYLxSDZwtyj44bdClNuZfHfbOwW7xkWqxJYtd2nzT8jaR6zcwEQ/p1A2
         L8gTnbrbiQpp28BgmOl2uwxdgFVRX1oxuhkWMz/UsdjQEGOVWbvNNvK3WSQEuoqfdN5W
         RvpZJs0a/k80/Qc0T+rl5cfl9nmAyXaJyO5TKo7ofadOX0PlQ7zphOpIAwjsSBuVESFv
         P0g7zeNm97ag2iuMT4dwgLmV1peBo0NiJokdY7tX88/Dj3eTHIfClPGx7mkyhGDlNJfR
         GmeSeoFOzZd3DVta7JojbBmTTc0aam+X82BdtMhY5KqT+cY9O8LtSmdcTj6S3pJujxCK
         sknw==
X-Gm-Message-State: AOJu0YzJgFA+DIy/AkBjZ/qGdWXhA3mqN4+TvOtLusloTz/YbdcE+6ix
	7WyYnHgx3rWvxa8q5YDCsR2pjuG4rUF05A==
X-Google-Smtp-Source: AGHT+IER6G6vf1boBQWR1f/NVaytAL1cbhoauw3YNUGdL/VGqMmYe1/wvEgro9ni7os7+BQBQDlnMQ==
X-Received: by 2002:a05:6902:1ac2:b0:db5:48f9:aff1 with SMTP id db2-20020a0569021ac200b00db548f9aff1mr3726685ybb.21.1702348096184;
        Mon, 11 Dec 2023 18:28:16 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:38aa:1c88:df05:9b73])
        by smtp.gmail.com with ESMTPSA id g13-20020a258a0d000000b00d8674371317sm2881700ybl.36.2023.12.11.18.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 18:28:15 -0800 (PST)
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
Subject: [PATCH v3 15/35] scsi: core: optimize scsi_evt_emit() by using an atomic iterator
Date: Mon, 11 Dec 2023 18:27:29 -0800
Message-Id: <20231212022749.625238-16-yury.norov@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231212022749.625238-1-yury.norov@gmail.com>
References: <20231212022749.625238-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A plain loop in scsi_evt_thread() opencodes optimized atomic bit traversing
macro. Simplify it by using the dedicated iterator.

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

