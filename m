Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A871EC001B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 08:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjF0Ic3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjF0Ibu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 04:31:50 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8073C2A
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:30:26 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4QqyZG5ZYwzBJBJT
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 16:29:58 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :subject:to:from:date:mime-version; s=dkim; t=1687854598; x=
        1690446599; bh=rY8FrVJSi19RgbCUiiSwhe+wareQggKiD1cqjZX3ejs=; b=U
        cSsWTLfQeymVyJyNCqgX+lb1njxOleAUQnLkW0NMACCSF+p+eIV7ufmdVOGoVipb
        Kro6sAcHTG/kXhn6ufOPlZ+djJOYKgnikjHcpkSrx6ytXNULb8DN/f4HTTpy6BeO
        H5NT6KXptSzIspm+HfrSxQ7+WrMQur3hBphHYzqC+m4H//98ZIQTCFm+lvJRd4Si
        Hl/0Spl1lYJyl+dnSzNkxWtfiLAuDIE0CcnLlEvOX/QEHAwogsmVcoMttjfEItaG
        dAqC17xl5mBPykelnKKfIml2eRv6KUZBOsDdhyLL3/IOancGam0fgDo9th9/6zJe
        ewme+kaJpve4MMOcD7nZA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PLTxWSyBkwpy for <linux-scsi@vger.kernel.org>;
        Tue, 27 Jun 2023 16:29:58 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4QqyZG2L09zBJBHT;
        Tue, 27 Jun 2023 16:29:58 +0800 (CST)
MIME-Version: 1.0
Date:   Tue, 27 Jun 2023 16:29:58 +0800
From:   baomingtong001@208suo.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ipr: Remove unneeded semicolon
User-Agent: Roundcube Webmail
Message-ID: <9d16962fccbd962abd25d0063f97df47@208suo.com>
X-Sender: baomingtong001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

./drivers/scsi/ipr.h:1916:2-3: Unneeded semicolon

Signed-off-by: Mingtong Bao <baomingtong001@208suo.com>
---
  drivers/scsi/ipr.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index c77d6ca1a210..583bbf9a7a93 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1913,7 +1913,7 @@ static inline int ipr_sdt_is_fmt2(u32 sdt_word)
  	case IPR_SDT_FMT2_BAR5_SEL:
  	case IPR_SDT_FMT2_EXP_ROM_SEL:
  		return 1;
-	};
+	}

  	return 0;
  }
-- 
2.40.1

