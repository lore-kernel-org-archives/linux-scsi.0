Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqLCWkkb"
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF81219B1;
	Sun,  3 Dec 2023 11:33:41 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id 006d021491bc7-58cf894544cso2560004eaf.3;
        Sun, 03 Dec 2023 11:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701632019; x=1702236819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnwy3GO4+/YbY9nFTKfS8ajWGLQcgGqwGxrShqVNeOY=;
        b=OqLCWkkb00xnke8A9/etKTCZq7lksueTG0SCAHawADaCGtJHokZeCh5nP0amOM6nhA
         LoqUxjn4oc31kKeRjqprft3kgwosCHyQ/naqMoWTHNMbWi/p5iCtzJ8zU0YwXs8n7J++
         glArqXq/y360jm8UNHxsIPf7RrPhxlwldKs5iwQGTvLOOAAMwUN15kpmn4PvuPtVjS/C
         Re+44Qq940lQDP0+/RZvBv3WF+oLhDWLL0gI2q7D8uU6q+sfyCO787WRkIZUWyYoOfDW
         hoPAgI5FGcMIOUvh5+fKZYmr30vYUnqxCH2fHWWWGQF7aR23/FD+cRPmmg4Do4S6botZ
         LheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701632019; x=1702236819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnwy3GO4+/YbY9nFTKfS8ajWGLQcgGqwGxrShqVNeOY=;
        b=U6xEgKqvJfMk7HaTDb6zz0zAsvb3XEFWaWg9kyvdowQNB70CMjBLac+hmGcpZUn+ww
         xoxv9MNM0hFflFsKG/ZD2iY0tF8DVoUEqG29JERbqHQ5hyvDNcD66K/QazxJQocqgqTp
         JBFbrVhW1O7zIuTnzsQzZd51benyWUCyLoxpHpQHZBcS9F5EnoBub96jAs+TBs7v88N1
         YB8355SyGNI9o4aMDXRmz3kBRQaajynMdJgkf6HWvMcBoaJIroUgsK5C7doI36xHnGcl
         YTs3pFFG0MKT8mQCGaSBV0QZTCMM5knrzXZwT41ISkn1adEKWN/mrb1s6MEOQ08zQxPl
         1NvA==
X-Gm-Message-State: AOJu0YyNX4KFypGnvbu5zwFIgJlhsxUWRNxL6v4gjYCuIZqRINL8D3k3
	nmhADEYruRnWiTAbZdPSQQgtO8STNOofdA==
X-Google-Smtp-Source: AGHT+IG+zD+BwFv03qVPmOUC8fU4F1e5Ipa6yHLGUdW2WuHA49paY/NKCSuKloULnbcWmRCF9+TUWg==
X-Received: by 2002:a05:6808:286:b0:3b8:9906:c267 with SMTP id z6-20020a056808028600b003b89906c267mr2304900oic.56.1701632018850;
        Sun, 03 Dec 2023 11:33:38 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:cb98:c3e:57c:8191])
        by smtp.gmail.com with ESMTPSA id 6-20020a250506000000b00d7745e2bb19sm1807611ybf.29.2023.12.03.11.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 11:33:37 -0800 (PST)
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
Subject: [PATCH v2 17/35] scsi: qedi: rework qedi_get_task_idx()
Date: Sun,  3 Dec 2023 11:32:49 -0800
Message-Id: <20231203193307.542794-16-yury.norov@gmail.com>
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

Simplify the function by using a dedicated find_and_set_bit().

CC: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/qedi/qedi_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cd0180b1f5b9..2f940c6898ef 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1824,20 +1824,13 @@ int qedi_get_task_idx(struct qedi_ctx *qedi)
 {
 	s16 tmp_idx;
 
-again:
-	tmp_idx = find_first_zero_bit(qedi->task_idx_map,
-				      MAX_ISCSI_TASK_ENTRIES);
+	tmp_idx = find_and_set_bit(qedi->task_idx_map, MAX_ISCSI_TASK_ENTRIES);
 
 	if (tmp_idx >= MAX_ISCSI_TASK_ENTRIES) {
 		QEDI_ERR(&qedi->dbg_ctx, "FW task context pool is full.\n");
 		tmp_idx = -1;
-		goto err_idx;
 	}
 
-	if (test_and_set_bit(tmp_idx, qedi->task_idx_map))
-		goto again;
-
-err_idx:
 	return tmp_idx;
 }
 
-- 
2.40.1

