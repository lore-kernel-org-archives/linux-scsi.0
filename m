Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B516C00A5A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 01:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjARBLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjARBK3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 20:10:29 -0500
X-Greylist: delayed 583 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 Jan 2023 17:04:53 PST
Received: from mail-m11874.qiye.163.com (mail-m11874.qiye.163.com [115.236.118.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451CB402FC
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 17:04:53 -0800 (PST)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11874.qiye.163.com (Hmail) with ESMTPA id 7927A3C0261;
        Wed, 18 Jan 2023 08:55:03 +0800 (CST)
Message-ID: <97210848-3e1a-637c-80bc-014fd78ff3d2@sangfor.com.cn>
Date:   Wed, 18 Jan 2023 08:54:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/2] scsi: iscsi: host ipaddress UAF fixes
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        haowenchao22@gmail.com, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20230117193937.21244-1-michael.christie@oracle.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <20230117193937.21244-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDHkNIVk9ISUkZHUsdSUJOQlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktPSEhVSktLVUtZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nhg6OAw*CD0aM0pCKhIzA1EZ
        LgEaCy1VSlVKTUxPS0tISEtMTk1NVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFJSkpPNwY+
X-HM-Tid: 0a85c25f590a2eb0kusn7927a3c0261
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/1/18 3:39, Mike Christie wrote:
> The following patches made apply over Martin's or Linus's trees. They
> fix 2 use after free bugs caused by iscsi_tcp using the session's socket
> to export the local IP address on the iscsi host to emulate the host's
> local IP address.
> 
> Note that the naming is not great because the libiscsi session removal
> and freeing functions are close to the iSCSI class's names. That will be
> fixed in a separate patch for the 6.3 or 6.4 kernel (depending on when
> this is merged) because it was a pretty big change fix up all the naming.
> 
> v2:
> - Fix bug reproducer example in git commit message.
> 

It looks good to me.

Thanks for your work on this.

-- 
Thanks,
- Ding Hui

