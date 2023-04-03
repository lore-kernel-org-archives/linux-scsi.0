Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3210CC761AF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 05:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjDCFUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 01:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjDCFUe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 01:20:34 -0400
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4826655A7;
        Sun,  2 Apr 2023 22:20:33 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id 827C9E1ABA;
        Mon,  3 Apr 2023 05:20:32 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 7331B60A47;
        Mon,  3 Apr 2023 05:20:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id ikKovPEy1rRc; Mon,  3 Apr 2023 05:20:32 +0000 (UTC)
Received: from [192.168.48.17] (host-184-164-23-94.dyn.295.ca [184.164.23.94])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id B78F3609E9;
        Mon,  3 Apr 2023 05:20:31 +0000 (UTC)
Message-ID: <0ff6fe6a-1661-f596-5d64-42499bb2798f@interlog.com>
Date:   Mon, 3 Apr 2023 01:20:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 08/11] scsi: scsi_debug: Use blk_mq_tagset_busy_iter()
 in stop_all_queued()
Content-Language: en-CA
To:     John Garry <john.g.garry@oracle.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
References: <20230327074310.1862889-1-john.g.garry@oracle.com>
 <20230327074310.1862889-9-john.g.garry@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230327074310.1862889-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-03-27 03:43, John Garry wrote:
> Instead of iterating all deferred commands in the submission queue
> structures, use blk_mq_tagset_busy_iter(), which is a standard API for
> this.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

