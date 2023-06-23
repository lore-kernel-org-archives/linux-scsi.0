Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62212EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 07:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjFWH0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 03:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjFWH0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 03:26:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9399AE7D
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 00:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F137D60F4D
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 07:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB819C433C0;
        Fri, 23 Jun 2023 07:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687505171;
        bh=CzBPIr0+268cylOFdwBQz9NC215z9Dxncx1lDo0wRAo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qkyNw7opJrbumAUGf/JULfgcLMPnk8a3VAFLA/C4GFC+FbvcNj616XlspsJ1Z6xJ3
         SOKXudLzwUAwE3mZlQSC/cDkyPLAXL3K13e5YBPpxWkMcN/KlDeKb3rSl7wA1cr9w6
         qMapM1LCsFWboaqUpJVlQB2gPW4OMh8FkrxI2MV55MmTfffxOGb/xxSUxN4tsNi5vg
         jEBowMue73uGNTjWCe9o5YjUe9Vlk7zk0oe3ZL6tZgzj2ibX2M3Da6Ut/IbT3SwNvO
         ZaHcjaYZ+r3eOqc9Fr33ihgYKCsCZJ80D1wKoNo4+a/TRtKc9P631aLOd21dCwDwhF
         69d3SVmDA4TBg==
Message-ID: <27177663-6ead-7a51-1037-1412a2b64d52@kernel.org>
Date:   Fri, 23 Jun 2023 16:26:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] scsi: Simplify scsi_cdl_check_cmd()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230623002912.808251-1-dlemoal@kernel.org>
 <ZJUwQvdRyr1v6wVX@infradead.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZJUwQvdRyr1v6wVX@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/23 14:40, Christoph Hellwig wrote:
>> +	 * See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES.
> 
> /one/on/ or even on the?

The spec has that as "One_command parameter data format", as opposed to the
other format which is "All_command parameter data format". Will re-phrase it
exactly like that.

-- 
Damien Le Moal
Western Digital Research

