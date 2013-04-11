From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] scsi_transport_iscsi: Declare portal type string
 macros for generic use
Date: Thu, 11 Apr 2013 17:20:08 -0500
Message-ID: <51673718.9020509@cs.wisc.edu>
References: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>  <5150FBF3.5050503@cs.wisc.edu> <1365718628.6982.0.camel@dabdike>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080900010906000804010102"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40806 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab3DKWUV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Apr 2013 18:20:21 -0400
In-Reply-To: <1365718628.6982.0.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lalit.chandivade@qlogic.com" <lalit.chandivade@qlogic.com>, "ravi.anand@qlogic.com" <ravi.anand@qlogic.com>, "poornima.vonti@qlogic.com" <poornima.vonti@qlogic.com>, "manish.rangankar@qlogic.com" <manish.rangankar@qlogic.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

This is a multi-part message in MIME format.
--------------080900010906000804010102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/11/2013 05:17 PM, James Bottomley wrote:
> On Mon, 2013-03-25 at 20:37 -0500, Mike Christie wrote:
>> Patches 1 - 3 look ok to me.
> 
> it looks like we're missing a patch 3/3?
> 

Did only I get it. I attached the mail I got with the patch in it.


--------------080900010906000804010102
Content-Type: message/rfc822;
 name="[PATCH 3_3] qla4xxx: Update driver version to 5.03.00-k7.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="[PATCH 3_3] qla4xxx: Update driver version to 5.03.00-k7.eml"

Return-Path: <vikas.chaudhary@qlogic.com>
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on slayer.cs.wisc.edu
X-Spam-Level: 
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_NEUTRAL autolearn=ham version=3.3.2
Received: from limestone.cs.wisc.edu (limestone.cs.wisc.edu [128.105.6.27])
	by crimson.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id r2PCvqPJ023683
	for <michaelc@crimson.cs.wisc.edu>; Mon, 25 Mar 2013 07:57:55 -0500
Received: from obsidian.cs.wisc.edu (obsidian.cs.wisc.edu [128.105.6.13])
	by limestone.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id r2PCvo7s024392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <michaelc@cs.wisc.edu>; Mon, 25 Mar 2013 07:57:50 -0500
Received: from linux-zupk.site (mvnat01.qlogic.com [198.186.3.73])
	by obsidian.cs.wisc.edu (8.14.1/8.14.1) with SMTP id r2PCvdmB004755
	for <michaelc@cs.wisc.edu>; Mon, 25 Mar 2013 07:57:40 -0500
Received: by linux-zupk.site (Postfix, from userid 0)
	id 19AF65220B3; Mon, 25 Mar 2013 08:08:43 -0400 (EDT)
From: vikas.chaudhary@qlogic.com
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com,
        lalit.chandivade@qlogic.com, ravi.anand@qlogic.com,
        poornima.vonti@qlogic.com, manish.rangankar@qlogic.com
Subject: [PATCH 3/3] qla4xxx: Update driver version to 5.03.00-k7
Date: Mon, 25 Mar 2013 08:08:33 -0400
Message-Id: <1364213313-17754-3-git-send-email-vikas.chaudhary@qlogic.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>
References: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>
X-Mailfromd-Misconfiguration: sending server 198.186.3.73 claimed to be server name linux-zupk.site, but that does not resolve; 
X-Mailfromd: Total of 1 misconfiguration (15 mins)
X-Mailfromd-Greylist-Time: May have had a total greylist delay of 15 minutes
X-Seen-By: mailfromd 4.1 obsidian.cs.wisc.edu

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index 0cd824f..18ad425 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.03.00-k6"
+#define QLA4XXX_DRIVER_VERSION	"5.03.00-k7"
-- 
1.8.2.GIT


--------------080900010906000804010102--
