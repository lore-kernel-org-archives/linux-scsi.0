From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] scsi: sd: add wce_rcd sysfs interface
Date: Wed, 17 Jan 2018 21:51:04 -0500
Message-ID: <yq1k1wfriav.fsf@oracle.com>
References: <20180117124945.GA7787@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeARCvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 21:51:15 -0500
In-Reply-To: <20180117124945.GA7787@bogon.didichuxing.com> (weiping zhang's
        message of "Wed, 17 Jan 2018 20:49:52 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org


Hi Weiping,

> add user friendly interface wce_rcd to enable/disable
> write&read cache. The code base on cache_type, but need short input.

While I agree that the cache_type interface is somewhat arcane, I don't
think that adding a duplicate interface with slightly different
semantics is a good idea.

-- 
Martin K. Petersen	Oracle Linux Engineering
