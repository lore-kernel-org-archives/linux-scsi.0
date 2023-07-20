Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBECEB64DC
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 07:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjGTHBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 03:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjGTHBC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 03:01:02 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C8D1719
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 00:01:00 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R63Vx1JKhzBRDsR
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 15:00:57 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689836457; x=1692428458; bh=M5N0YuOJvY1LVz6L6CJU9dKdNo9
        1zmyFhItYmRTSGt4=; b=eIkYZBZeCm551cg1fi6afWl9AFgTKxFD014kxEYNq8T
        IYDZ0FOX9hfK2GztCxejfdMEZKGWHRnxJfU5QEbh6TSQrcbIgzyAYB0m78H1Zvui
        8knwHH8elKBwKWLcQAR23IR+juI70VAAZV5hwQHrBmcOi4raAGFfFUgu8ssiuwOF
        dQW4ZSMiBYQtNyLRRWWcF0DzXemTn3gEkLS8Bmx2SNhlTgoZHZ1dPSpX1cvbp2Vl
        8iZi4frfJkAtjfpH7GTWgeQb8HH3Y9g40y0VLhMKFIsJzthFut817jaVOrATm62i
        0HdrzMhtk6Vfmi30DPv3PALRDmR3cuVdlcpMPo5k/cw==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MfcWOurtkT4R for <linux-scsi@vger.kernel.org>;
        Thu, 20 Jul 2023 15:00:57 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R63Vw5jYQzBRDsD;
        Thu, 20 Jul 2023 15:00:56 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 20 Jul 2023 15:00:56 +0800
From:   sunran001@208suo.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] aic7xxx: add missing spaces
In-Reply-To: <20230720065939.2838-1-xujianghui@cdjrlc.com>
References: <20230720065939.2838-1-xujianghui@cdjrlc.com>
User-Agent: Roundcube Webmail
Message-ID: <73b47a5b0c3b263a4c002edbfb6afd12@208suo.com>
X-Sender: sunran001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add missing spaces to clear checkpatch errors.

ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Ran Sun <sunran001@208suo.com>
---
  drivers/scsi/aic7xxx/queue.h | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/queue.h b/drivers/scsi/aic7xxx/queue.h
index ba602981f193..f6e958a5f973 100644
--- a/drivers/scsi/aic7xxx/queue.h
+++ b/drivers/scsi/aic7xxx/queue.h
@@ -481,9 +481,9 @@ struct {								\

  #define	CIRCLEQ_LAST(head)	((head)->cqh_last)

-#define	CIRCLEQ_NEXT(elm,field)	((elm)->field.cqe_next)
+#define	CIRCLEQ_NEXT(elm, field)	((elm)->field.cqe_next)

-#define	CIRCLEQ_PREV(elm,field)	((elm)->field.cqe_prev)
+#define	CIRCLEQ_PREV(elm, field)	((elm)->field.cqe_prev)

  #define	CIRCLEQ_REMOVE(head, elm, field) do {				\
  	if (CIRCLEQ_NEXT((elm), field) == (void *)(head))		\
