Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C7EC001E0
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 09:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjGYJUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 05:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjGYJUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 05:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805B12699;
        Tue, 25 Jul 2023 02:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06F3C6156E;
        Tue, 25 Jul 2023 09:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97715C433C9;
        Tue, 25 Jul 2023 09:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690276782;
        bh=Ytq421TntNLvtFQFIrwUBDkNKKRbHryaour5aP3dS30=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=moZYquJ7a+NFgdAuXa5vvJ/UqdUUx9lS9mMzFDtyXPohQJm6CJJmAE2myCFLcfwEK
         q5GcgYKZeJINRRSWVJeOh6kQSbpgO0TfYr4O1d2BoV76zRaTf2glBkYLTFZB1p9TZY
         Xf4xKpDxzc2LtVGHdwLyujKy5fIM3YmfkW335RPrP6CNsUwyTfV4fA/C6X7LkpUy61
         /+eNjoL/4HEKe0A059BeB8ZhvCwWgdmOPNOEj49wj+4YibqoaTLPhF/++uptXYMmD8
         V4uoXoHTgcWVQwHPEjq7uOVh7SrlwZc/bn2bWfXxyXo2p8TVLQXnJkmytdBPSfhz1n
         Q3Gz1/v3+sy9w==
Message-ID: <a682e9ce-b0a9-b918-0887-40bf031450d3@kernel.org>
Date:   Tue, 25 Jul 2023 17:19:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5] scsi: support packing multi-segment in UNMAP command
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230310123604.1820231-1-chao@kernel.org>
 <b53321ab-679d-e007-6407-6bd00149948e@kernel.org>
 <yq17ct0nijm.fsf@ca-mkp.ca.oracle.com>
 <f93949dd-e90f-a9bf-33b3-4f31c4328c7d@kernel.org>
 <yq1sfabni01.fsf@ca-mkp.ca.oracle.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <yq1sfabni01.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/6/29 10:02, Martin K. Petersen wrote:
> I'll resubmit this series for 6.6.

Hi, Martin

Ping to avoid missing this patch in 6.6. :)

Thanks,
