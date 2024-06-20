Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC221C004A;
	Thu, 20 Jun 2024 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906276; cv=none; b=jqvn+EZjKzajz/ZLH+2m7ARIO3ZLdaTs2C7sA9ArwSWp5IeuDdtDK3kwPybn4NFDVp85SBTavJ/3SoTVSOg1WOH0X7TD3anUaW/UXpkGIP0+64KrGXmQYtffkVtYHvVWdkCvQEYmvnYbPjHdEnYjRXk43UPtYVIxW1fUTBYeQTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906276; c=relaxed/simple;
	bh=VYKqh/NkznC9CObWrWdbjElllM8wu6NtGW8jRbGEu1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAsgiH9pWatjfArkMPTl0tOhDz62soZ3C0EsPPt8lQxRfvJlnnrXOuzrtggpBwrZ/Wj9nDCF19NG+itouOaLlH7TdRUAj6xAqQyb5cZyy3abHyAtatWOgGaiZxPCdCO/i/dKmNBCKBLjinMe7A9RrE2KKGsfLHS/di+aGbeOpio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CN8aEbr7; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CN8aEbr7"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2c2dee9d9cfso1010579a91.3;
        Thu, 20 Jun 2024 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718906275; x=1719511075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gLFCykJTwTUyj41nXgH0cr48eAqtsmwHylJ+z5USpc=;
        b=CN8aEbr7JOpbChEUsh8Z4WRFqaJBOzmngQqDdE6+TgwkZV9HCs9Ro/p3qd7gkhQ8hT
         gQlrozxxJ2bmwEWOPXOWRILrsgPtHFMUelHNmz/LaMsg4bqU0utI9Lu31za0F24Cr8U1
         3WeLjf5GV2XGJGobsHX+kwH58/VbNbi/G9IDC5hRBWm8cH2QAX0eheQ6kzO60Z/IzhyJ
         FYlSWpwOiQJ1JVm+OtfzZXjHrDQJW9zhq1Do5jiZRRMGZ4DbKQ+r8wwLsnhGaVBcHRSi
         iGllA+mmrQHCpQDdFnRbbq8yJDsW+GznQqjmQBBAUnQSA0OPprjvyDGW18F+RkwLW/oV
         7qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906275; x=1719511075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8gLFCykJTwTUyj41nXgH0cr48eAqtsmwHylJ+z5USpc=;
        b=cLWvrDm+XvSeq6iOmRxkOjJ/1mQNI6/6ztMkIu45I6QsJdPT8omKxF2y8Wa8M07rJW
         JLjkwR1mi4MK+6AlNmlJYvlAgOGhg8RS4I0UZPS6/bcQIBPvR1YpbwG1kWlgveeedPGn
         Md+4TAD0xWP0EQsjfvGgFkLJR10UZUIzxIroQBtGSnqLZV+9z8r9ORxviSR3zqaQTSNY
         9eQSl3aTguRIioghagYbs05REk8+aGWri7lqxRLt55gAhpzAlauhv3ociHzpfEZu53my
         kX2mrJKUczN9YJhNZ/eDMRizOYTnDVBKmEo5u5FkS9CVlqwMYI1KPL94t3Mp0A+Cmc8N
         B/Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVU8T7ol06G7OKunj++sE7KK4jGrSDB2tpoCFF1tWqyp6vO7UtHxVVf7DrgxLoqGQswDC+ZFL2Jm15fhK6NCi2SUMOhIXI1GZgxCw==
X-Gm-Message-State: AOJu0YyIAtaEejUvaPt3w0AxFi/sODWXK+gaDmyOjx7oSCfhb/XUb9UC
	D+x9BQT4zYZXE/xfL/WtSw9In5Mz1ga908TIjjzCFeam+YCpyQioN4vZKLG5nb8=
X-Google-Smtp-Source: AGHT+IEs3xkwMF/QaqEF7eP2EEue34uat1uHueDoae/eLjPzmkBpQNQnWmyoCgGGoO7izL2d+Mf08A==
X-Received: by 2002:a17:90b:4c43:b0:2c8:647:1600 with SMTP id 98e67ed59e1d1-2c80647165emr1512425a91.9.1718906274840;
        Thu, 20 Jun 2024 10:57:54 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c7e53ea477sm2023501a91.17.2024.06.20.10.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 10:57:54 -0700 (PDT)
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
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v4 16/40] scsi: mpi3mr: optimize the driver by using find_and_set_bit()
Date: Thu, 20 Jun 2024 10:56:39 -0700
Message-ID: <20240620175703.605111-17-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620175703.605111-1-yury.norov@gmail.com>
References: <20240620175703.605111-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mpi3mr_dev_rmhs_send_tm() and mpi3mr_send_event_ack() opencode
find_and_set_bit(). Simplify them by using dedicated function.

CC: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index bce639a6cca1..8ad1521dd0b3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -7,6 +7,7 @@
  *
  */
 
+#include <linux/find_atomic.h>
 #include "mpi3mr.h"
 #include <linux/idr.h>
 
@@ -2292,13 +2293,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	if (drv_cmd)
 		goto issue_cmd;
 	do {
-		cmd_idx = find_first_zero_bit(mrioc->devrem_bitmap,
-		    MPI3MR_NUM_DEVRMCMD);
-		if (cmd_idx < MPI3MR_NUM_DEVRMCMD) {
-			if (!test_and_set_bit(cmd_idx, mrioc->devrem_bitmap))
-				break;
-			cmd_idx = MPI3MR_NUM_DEVRMCMD;
-		}
+		cmd_idx = find_and_set_bit(mrioc->devrem_bitmap, MPI3MR_NUM_DEVRMCMD);
+		if (cmd_idx < MPI3MR_NUM_DEVRMCMD)
+			break;
 	} while (retrycount--);
 
 	if (cmd_idx >= MPI3MR_NUM_DEVRMCMD) {
@@ -2433,14 +2430,9 @@ static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 	    "sending event ack in the top half for event(0x%02x), event_ctx(0x%08x)\n",
 	    event, event_ctx);
 	do {
-		cmd_idx = find_first_zero_bit(mrioc->evtack_cmds_bitmap,
-		    MPI3MR_NUM_EVTACKCMD);
-		if (cmd_idx < MPI3MR_NUM_EVTACKCMD) {
-			if (!test_and_set_bit(cmd_idx,
-			    mrioc->evtack_cmds_bitmap))
-				break;
-			cmd_idx = MPI3MR_NUM_EVTACKCMD;
-		}
+		cmd_idx = find_and_set_bit(mrioc->evtack_cmds_bitmap, MPI3MR_NUM_EVTACKCMD);
+		if (cmd_idx < MPI3MR_NUM_EVTACKCMD)
+			break;
 	} while (retrycount--);
 
 	if (cmd_idx >= MPI3MR_NUM_EVTACKCMD) {
-- 
2.43.0

