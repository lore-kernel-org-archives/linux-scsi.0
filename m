From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libsas: do not set res = 0 in sas_ex_discover_dev()
Date: Fri, 06 Nov 2009 13:12:27 -0600
Message-ID: <1257534748.2715.265.camel@mulgrave.site>
References: <6B62480106F2B34D8404CF2FDAA4D9EF38546AA22B@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	 <e938503f0910181843q1569ca1eo34b3af884cefb45e@mail.gmail.com>
	 <63412251C6BA4D16B1721701D56292B8@usish.com.cn>
	 <6B62480106F2B34D8404CF2FDAA4D9EF38546AA598@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	 <9363F2E7DE9C4DBAB057D40324240F96@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZKFTMe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Nov 2009 14:12:34 -0500
In-Reply-To: <9363F2E7DE9C4DBAB057D40324240F96@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, 'Srinivas Naga Venkatasatya Pasagadugula' <satyasrinivasp@hcl.in>, 'Tom Peng' <tom_peng@usish.com>, 'andy yan' <andyysj@gmail.com>, aoqingyun@usish.com

On Thu, 2009-11-05 at 15:56 +0800, jack wang wrote:
> Hi, James
> 
> What is the status of this this patch .  we have test it  Srinivas
> have confirmed it does work.
> 
> Please consider to include it in your rc-fixes tree.

OK, this one never actually made it to the list.  I think this was
because all the patches contained text/html attachments which the list
kills sight unseen because it thinks they're spam.  You really have to
make sure you only send text plain and patch attachments for them to get
through.

For simplicity, the patch is below for list review.

James

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



