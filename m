From: christophe.varoqui@free.fr
Subject: Re: [sg3_utils] report target group
Date: Wed, 29 Dec 2004 14:43:01 +0100
Message-ID: <1104327781.41d2b4654846d@imp5-q.free.fr>
References: <1104233396.41d143b44e073@imp5-q.free.fr> <41D21DDD.5010109@torque.net> <1104307397.41d264c5c5d3c@imp5-q.free.fr> <41D2AF42.5050007@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:38081 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S261344AbUL2NnD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 08:43:03 -0500
In-Reply-To: <41D2AF42.5050007@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Very nice.

May you should consider this small incremental
And rename the file to sg_rtpg.c

... for coherency.

--- sg_rtg.c    2004-12-29 17:40:16.000000000 +0100
+++ sg_rtg.c.cva        2004-12-29 17:44:33.000000000 +0100
@@ -114,7 +114,7 @@
         printf(" (no status available)");
         break;
     case STATUS_CODE_CHANGED_BY_SET:
-        printf(" (status changed by SET TARGET GROUP)");
+        printf(" (status changed by SET TARGET PORT GROUP)");
         break;
     case STATUS_CODE_CHANGED_BY_IMPLICIT:
         printf(" (status changed by implicit TPGS behaviour)");
@@ -247,7 +247,7 @@
             ret = 0;
             goto err_out;
         }
-        printf("Report target groups:\n");
+        printf("Report target port groups:\n");
         for (k = 4, ucp = reportTgtGrpBuff + 4; k < report_len;
              k += off, ucp += off) {

Selon Douglas Gilbert <dougg@torque.net>:

> I have uploaded a new beta of the sg3_utils v1.12
> tarball. The response decoding in sg_rtg has been
> reworked.
>
> If the '#define TEST_CODE" line is uncommented in
> sg_rtg.c then the utility will decode a dummy response
> (constructed from the SPC-3 v21b response description).
> I also took some liberties with the formatting.
>
