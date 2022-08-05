Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE28AC00140
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Aug 2022 10:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbiHEKJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Aug 2022 06:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiHEKJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2022 06:09:25 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A1C6715E
        for <linux-scsi@vger.kernel.org>; Fri,  5 Aug 2022 03:09:23 -0700 (PDT)
Received: from fsav414.sakura.ne.jp (fsav414.sakura.ne.jp [133.242.250.113])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 275A4L1f021986;
        Fri, 5 Aug 2022 19:04:21 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav414.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp);
 Fri, 05 Aug 2022 19:04:21 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 275A4KAM021962
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Aug 2022 19:04:20 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <cafa1228-d9be-69a6-b748-4f4503315f74@I-love.SAKURA.ne.jp>
Date:   Fri, 5 Aug 2022 19:04:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v4 1/4] scsi: qla2xxx: Remove unused del_sess_list field
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <4b3c4c8f-02b0-4d95-85ef-9368b5557cbf@I-love.SAKURA.ne.jp>
 <yq1v8s84ne7.fsf@ca-mkp.ca.oracle.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <yq1v8s84ne7.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nilesh, I still can't find this series in linux-next.git.

What is the status of this series?

On 2022/07/08 6:35, Martin K. Petersen wrote:
> 
> Nilesh,
> 
>> "struct qla_tgt"->del_sess_list is no longer used since commit
>> 726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").
> 
> Please review and test this series. Thank you!
> 

