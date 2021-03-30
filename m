Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041A5C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B958D61935
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhC3HNl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:13:41 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:38074 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhC3HND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 03:13:03 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.232])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id B6735E02FA;
        Tue, 30 Mar 2021 15:05:49 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wang Qing <wangqing@vivo.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 6/6] net/decnet: Delete obsolete TODO file
Date:   Tue, 30 Mar 2021 15:02:49 +0800
Message-Id: <1617087773-7183-7-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTk0fTkJNGE8eTExMVkpNSkxLQ0xCTktDTkhVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PCI6CAw*Tz8UAjcXPh88TgE8
        Ej0aCk5VSlVKTUpMS0NMQk5KSkxKVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISVlXWQgBWUFPS0xNNwY+
X-HM-Tid: 0a7881f3eed02c17kusnb6735e02fa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The TODO file here has not been updated from 2005, and the function 
development described in the file have been implemented or abandoned.

Its existence will mislead developers seeking to view outdated information.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 net/decnet/TODO | 40 ----------------------------------------
 1 file changed, 40 deletions(-)
 delete mode 100644 net/decnet/TODO

diff --git a/net/decnet/TODO b/net/decnet/TODO
deleted file mode 100644
index 358e9eb..0000000
--- a/net/decnet/TODO
+++ /dev/null
@@ -1,40 +0,0 @@
-Steve's quick list of things that need finishing off:
-[they are in no particular order and range from the trivial to the long winded]
-
- o Proper timeouts on each neighbour (in routing mode) rather than
-   just the 60 second On-Ethernet cache value.
-
- o Support for X.25 linklayer
-
- o Support for DDCMP link layer
-
- o The DDCMP device itself
-
- o PPP support (rfc1762)
-
- o Lots of testing with real applications
-
- o Verify errors etc. against POSIX 1003.1g (draft)
-
- o Using send/recvmsg() to get at connect/disconnect data (POSIX 1003.1g)
-   [maybe this should be done at socket level... the control data in the
-    send/recvmsg() calls should simply be a vector of set/getsockopt()
-    calls]
-
- o check MSG_CTRUNC is set where it should be.
-
- o Find all the commonality between DECnet and IPv4 routing code and extract
-   it into a small library of routines. [probably a project for 2.7.xx]
-
- o Add perfect socket hashing - an idea suggested by Paul Koning. Currently
-   we have a half-way house scheme which seems to work reasonably well, but
-   the full scheme is still worth implementing, its not not top of my list
-   right now.
-
- o Add session control message flow control
-
- o Add NSP message flow control
-
- o DECnet sendpages() function
-
- o AIO for DECnet
-- 
2.7.4

