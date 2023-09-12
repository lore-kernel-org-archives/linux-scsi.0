Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26049CA0ED8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjILImY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjILImO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:42:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493E41713
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 01:41:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC2CC433C8;
        Tue, 12 Sep 2023 08:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694508098;
        bh=QXwG6cztqDiczgjjno5jasHRCVtvze6JPNgJo2bL13s=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=QnSJDo9B5hVXekYer7YM3HkbmS5oxxiFuzojaXzMZCQKr2mZ/XY0IyvrMWwNgCzcg
         MzFLD6vFCxsvlRGx4H45A03G5w42EqgHYJX3gnSeM3Ggea5g+EsspyEGu0h082wy60
         qn4xOH5Hawf1s4cJcCsFBG2UGaZvOs25cpieLpnNzh37u9NdOAbk+ELBA7QaYOjgAX
         cqSmMLXIuzAyyYILbOARbeWGigG/kPANWFMHwYTG+ZZmZ5N4T3/zAtYj9tZCHClome
         SQ9zRJ3V5BFk0Uri8j8RrEhA6dR+VqmlIMXtGv/F0uzCqmGkjPC3+d9in+i78JBip/
         y3KZwOPjIv8tA==
Message-ID: <4d905688-8baa-8b1a-ffce-ac8b3851a69f@kernel.org>
Date:   Tue, 12 Sep 2023 17:41:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/3] scsi: libsas: Move local functions declarations to
 sas_internal.h
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230912074715.424062-1-dlemoal@kernel.org>
 <20230912074715.424062-2-dlemoal@kernel.org>
 <ced3c45a-047a-58d2-31e3-0b0de9ea0af4@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ced3c45a-047a-58d2-31e3-0b0de9ea0af4@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/23 17:19, John Garry wrote:
> On 12/09/2023 08:47, Damien Le Moal wrote:
>> Move the declarations of functions used only within libsas from
>> include/scsi/libsas.h to drivers/scsi/libsas/sas_internal.h
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
>>   
>> -void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
>> -
>>   void sas_init_dev(struct domain_device *);
> 
> I think that this guy can also be relocated

ah! yes. My grep hit hisi_sas, but that was another function.
Adding it.

> 
>>   
>>   void sas_task_abort(struct sas_task *);
> 

-- 
Damien Le Moal
Western Digital Research

