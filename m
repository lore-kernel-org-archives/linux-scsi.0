From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: csiostor: fix use after free in
 csio_hw_use_fwconfig()
Date: Thu, 18 May 2017 09:00:12 +0200
Message-ID: <db1ac799-d614-4e7d-7fcc-1021cf70a8ba@suse.de>
References: <1495033243-20262-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752075AbdERHAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 03:00:14 -0400
In-Reply-To: <1495033243-20262-1-git-send-email-varun@chelsio.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, rajesh.kumar@chelsio.com

On 05/17/2017 05:00 PM, Varun Prakash wrote:
> mbp pointer is passed to csio_hw_validate_caps() so call
> mempool_free() after calling csio_hw_validate_caps().
> 
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---

Fixes: 541c571fa2fd ("csiostor:Use firmware version from
cxgb4/t4fw_version.h")
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
