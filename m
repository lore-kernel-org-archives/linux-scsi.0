From: "=?utf-8?B?amFja193YW5n?=" <jack_wang@usish.com>
Subject: =?utf-8?B?UmU6IFJlOiBbUEFUQ0hdIGxpYnNhczogZG8gbm90IHNldCByZXMgPSAwIGluIHNhc19leF9kaXNjb3Zlcl9kZXYoKQ==?=
Date: Sat, 7 Nov 2009 06:36:53 +0800
Message-ID: <200911070636527812488@usish.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF38546AA22B@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>,
 <e938503f0910181843q1569ca1eo34b3af884cefb45e@mail.gmail.com>,
 <63412251C6BA4D16B1721701D56292B8@usish.com.cn>,
 <6B62480106F2B34D8404CF2FDAA4D9EF38546AA598@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>,
 <9363F2E7DE9C4DBAB057D40324240F96@usish.com.cn>,
 <1257534748.2715.265.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:54147 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbZKFWgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2009 17:36:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?SmFtZXMgQm90dG9tbGV5?= <James.Bottomley@suse.de>
Cc: =?utf-8?B?bGludXgtc2NzaQ==?= <linux-scsi@vger.kernel.org>, =?utf-8?B?J1NyaW5pdmFzIE5hZ2EgVmVua2F0YXNhdHlhIFBhc2FnYWR1Z3VsYSc=?= <satyasrinivasp@hcl.in>, =?utf-8?B?J1RvbSBQZW5nJw==?= <tom_peng@usish.com>, =?utf-8?B?J2FuZHkgeWFuJw==?= <andyysj@gmail.com>, =?utf-8?B?YW9xaW5neXVu?= <aoqingyun@usish.com>

OK, this one never actually made it to the list.  I think this was
because all the patches contained text/html attachments which the list
kills sight unseen because it thinks they're spam.  You really have to
make sure you only send text plain and patch attachments for them to get
through.

For simplicity, the patch is below for list review.

James
 [Jack] Sorry for that, We will make sure text/html things will never happen in the future. 
And thanks for you help.
---

From: jack wang <jack_wang@usish.com>
Subject: [PATCH] libsas: do not set res = 0 in sas_ex_discover_dev()

We should not set res to 0 in function sas_ex_discover_dev  in order to let
it discover it further when wide port hotplug in .

Signed-off-by: Tom Peng <tom_peng@usish.com>
Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/libsas/sas_expander.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b338195..33cf988 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -960,7 +960,6 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 
 			}
 		}
-		res = 0;
 	}
 
 	return res;
-- 
1.6.4.2



