From: Marina Makienko <makienko@ispras.ru>
Subject: [PATCH] target: Add blk_put_request()
Date: Fri, 10 Aug 2012 18:02:35 +0400
Message-ID: <1344607355-9310-1-git-send-email-makienko@ispras.ru>
References: <1344585899-31466-1-git-send-email-makienko@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1344585899-31466-1-git-send-email-makienko@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Marina Makienko <makienko@ispras.ru>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@ispras.ru
List-Id: linux-scsi@vger.kernel.org

blk requests are obtained (some memory is allocated for them)
by means of functions blk_get_request and blk_make_request.
After usage (usually with help of blk_execute_rq) these requests
should be put (and freed) with help of blk_put_request.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
There is no problems in drivers/target/target_core_pscsi.c

Please ignore the previous message. 
-- 
1.7.7
