Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2FEE95A67
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Oct 2023 23:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344921AbjJHXOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Oct 2023 19:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344437AbjJHXOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Oct 2023 19:14:06 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7638C9D;
        Sun,  8 Oct 2023 16:14:05 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 95C7A765D3;
        Sun,  8 Oct 2023 23:14:04 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 7F9296091F;
        Sun,  8 Oct 2023 23:14:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id vr5ko5C6duzg; Sun,  8 Oct 2023 23:14:03 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-209-188.dyn.295.ca [104.157.209.188])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 95C4B60455;
        Sun,  8 Oct 2023 23:14:02 +0000 (UTC)
Message-ID: <a517343d-cd37-4faa-8c26-c4e0c1217777@interlog.com>
Date:   Sun, 8 Oct 2023 19:14:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v5 09/10] scsi: scsi_debug: Add debugfs interface to fail
 target reset
Reply-To: dgilbert@interlog.com
To:     Wenchao Hao <haowenchao2@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, louhongxiang@huawei.com,
        kernel test robot <oliver.sang@intel.com>
References: <20230922092906.2645265-1-haowenchao2@huawei.com>
 <20230922092906.2645265-10-haowenchao2@huawei.com>
Content-Language: en-CA
In-Reply-To: <20230922092906.2645265-10-haowenchao2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-09-22 05:29, Wenchao Hao wrote:
> The interface is found at
> /sys/kernel/debug/scsi_debug/target<h:c:t>/fail_reset where <h:c:t>
> identifies the target to inject errors on. It's a simple bool type
> interface which would make this target's reset fail if set to 'Y'.
> 
> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

Tested by setting 'echo 1 > /sys/bus/pseudo/drivers/scsi_debug/opts'
and observing 'tail -f /var/log/syslog'. Looks good including that
fail_reset is readable so its current state can be checked.

Tested-by: Douglas Gilbert <dgilbert@interlog.com>

<snip>


