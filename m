Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822F3CD68E4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 02:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441885AbjJJCX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 22:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441921AbjJJCX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 22:23:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB489C;
        Mon,  9 Oct 2023 19:23:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBA4C433C7;
        Tue, 10 Oct 2023 02:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696904631;
        bh=xUneNrpB3V7czNbgze2OVGrMg4DQXkpwhj5F1kFMQUA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=N5991IKXMTpNt7vP+nIWpcS+UZlwbFpIQQi1yXe11pEDpezU3P1qpcz+LbwXHISyb
         aISSYS1KakBfyeUNyLOqx/73kWnGlLUd5h4JxLlXk0bGZ2z/YJ/7sAZwn3MdK+smpz
         m0wqfMWgG3J/1esvTdScnmBhs72m1J5NfGJW/iAM4YXaxJsoaBwiPS+P0TFLpiFDH4
         4x3v6+qFv1YEa+ysfmVOKEYzB6XdSV7IqDcwhzjtKqzRjV6ki6QRQrcMoIpXhLf/yA
         rnRcS7sI9K82R+2SNzIEFmnnbzzdHmHgihk6ymo0/9V06dmNEIBioyEk+icpt9HDTt
         9rjDuj5JVjJhw==
Message-ID: <551309ec-cce1-42b1-a823-33a0505960fb@kernel.org>
Date:   Tue, 10 Oct 2023 11:23:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Do not rescan devices with a suspended queue
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     =?UTF-8?B?UGV0ciBUZXNhxZnDrWs=?= <petr@tesarici.cz>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231004085803.130722-1-dlemoal@kernel.org>
 <20231009081736.28ddb5fe@meshulam.tesarici.cz>
 <c05ba025-48f3-4c76-b4db-bceeff5d4f03@kernel.org>
 <yq1r0m3ntk8.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <yq1r0m3ntk8.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/23 10:43, Martin K. Petersen wrote:
> 
> Damien,
> 
>>> FTR this fix is still needed for rc5. Is there any chance it goes
>>> into fixes before v6.6 is final?
>>
>> The patch is on the scsi list, not for libata. Martin will likely
>> apply it this week.
> 
> Patch looks good to me but I can't apply since the PM rework series went
> through your tree. My fixes branch is based on -rc1. So I'd prefer for
> you to take it.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

OK. Thanks !

-- 
Damien Le Moal
Western Digital Research

