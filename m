Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6F3EB64DA
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 06:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjGTGkf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 02:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjGTGkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 02:40:19 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331EC30FC
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 23:39:37 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R631d4qftzBRDsN
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 14:39:01 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689835141; x=1692427142; bh=QQ4F6/NsViTAdHqa0Q2JmIWKtN/
        0Miytj1rY2XW/4Sc=; b=L65OXSFRzV/28Rcz8ukL9Grtu/e4CE0SCtv3s7IRxNn
        huTl65AHbBsIhB39mVFP6UUv4N6fsVGyJP/y5IBiGX5LQbZaTRO1S+7/FhrwLLYG
        MSmULSuu5hePloKlNYd5ncS8dmgdwaIp1JNHW6HkPVHRfI5wBTPjG+F9egUxaUG2
        peA8a++blIQxq4Rr1HfKTo9aKDfd9CrGkCDMoFAudkdLpPGCwP8j0JHYHyy0qBFL
        iIAoNf7WG/m0Fvml1x1TKOLLMwhVr9S6ghkZ8yzxLOJyShlbZfnynb/AqaY94O8z
        cy9mAOcuMo6q99XQwDqWHro6iPcfuDdTuAJJBAmluqg==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4Ghc2KzcAtsw for <linux-scsi@vger.kernel.org>;
        Thu, 20 Jul 2023 14:39:01 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R631d2F0bzBRDsD;
        Thu, 20 Jul 2023 14:39:01 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 20 Jul 2023 14:39:01 +0800
From:   sunran001@208suo.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: add missing spaces
In-Reply-To: <20230720063719.2618-1-xujianghui@cdjrlc.com>
References: <20230720063719.2618-1-xujianghui@cdjrlc.com>
User-Agent: Roundcube Webmail
Message-ID: <e8abfa9b5579c6ed85ed35662bac290b@208suo.com>
X-Sender: sunran001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add missing spaces to clear checkpatch errors.

ERROR: space required before the open parenthesis '('
ERROR: spaces required around that '=' (ctx:VxW)
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Ran Sun <sunran001@208suo.com>
---
  drivers/scsi/aic7xxx/aicasm/aicasm.c | 8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c 
b/drivers/scsi/aic7xxx/aicasm/aicasm.c
index cd692a4c5f85..a22f0fffc9b9 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -396,7 +396,7 @@ output_code()

  	for (cur_node = SLIST_FIRST(&patch_functions);
  	     cur_node != NULL;
-	     cur_node = SLIST_NEXT(cur_node,links)) {
+	     cur_node = SLIST_NEXT(cur_node, links)) {
  		fprintf(ofile,
  "static %spatch_func_t %spatch%d_func;\n"
  "\n"
@@ -424,7 +424,7 @@ output_code()

  	for (cur_patch = STAILQ_FIRST(&patches);
  	     cur_patch != NULL;
-	     cur_patch = STAILQ_NEXT(cur_patch,links)) {
+	     cur_patch = STAILQ_NEXT(cur_patch, links)) {
  		fprintf(ofile, "%s\t{ %spatch%d_func, %d, %d, %d }",
  			cur_patch == STAILQ_FIRST(&patches) ? "" : ",\n",
  			prefix,
@@ -638,7 +638,7 @@ output_listing(char *ifilename)
  		instrptr++;
  	}
  	/* Dump the remainder of the file */
-	while(fgets(buf, sizeof(buf), ifile) != NULL)
+	while (fgets(buf, sizeof(buf), ifile) != NULL)
  		fprintf(listfile, "             %s", buf);

  	fclose(ifile);
@@ -747,7 +747,7 @@ cs_alloc()
  {
  	critical_section_t *new_cs;

-	new_cs= (critical_section_t *)malloc(sizeof(critical_section_t));
+	new_cs = (critical_section_t *)malloc(sizeof(critical_section_t));
  	if (new_cs == NULL)
  		stop("Unable to malloc critical_section object", EX_SOFTWARE);
  	memset(new_cs, 0, sizeof(*new_cs));
