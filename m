Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3221C77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 16 May 2023 03:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjEPDhL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 23:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjEPDhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 23:37:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00D85594
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2023 20:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38CCD60BB1
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 03:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0287DC4339B;
        Tue, 16 May 2023 03:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684208227;
        bh=nlSIKoPfG+ruBJF7gUzVDjwyeJOVS7ze4Y+tSydd5ng=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QSUUEt6p5EIpR3BoME3VH8lFo3fXU7yKq7VhFpD6AGeZU7H3uIUm1hNe53pEPjMSY
         5GudN765yLdtNjbZsz7dQybdwqAmuWTElUalleRJ+REowUcnA2DdkXOlN+qusmlcSk
         WaoRWdV7CL9OmIdPN3yY09DXCHzZTwJJ3a2lCikbUZY5Dk82i6ZviE/dewauItTrEu
         TuOQzqyMwgCWYYc+cBptxGQghb4XthzH6n3EtBxH8flOidl1J/JaL7kwg0NtYfXfMw
         js9bjulTHt4xOdEb8X3pbCHFg/DIx2XTvtWkdJwE5VGd8B88sx9ULPYx1byyV9/2G0
         X3o5FhhlO9kYA==
Message-ID: <b4a8371b-eed6-9420-4ed9-5435ed1ba90c@kernel.org>
Date:   Tue, 16 May 2023 12:37:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH] scsi: MAINTAINERS: Add a libsas entry
To:     Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
References: <20230516025343.2050704-1-yanaijie@huawei.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230516025343.2050704-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/05/16 11:53, Jason Yan wrote:
> John has been reviewing libsas patches for years. And I have been
> contributing to libsas for years and I am interested in reviewing and
> testing libsas patches too. So add a libsas entry and add John and me
> as reviewer.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e0b87d5aa2e..a789811f6092 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18767,6 +18767,16 @@ F:	include/linux/wait.h
>  F:	include/uapi/linux/sched.h
>  F:	kernel/sched/
>  
> +SCSI LIBSAS SUBSYSTEM
> +R:	John Garry <john.g.garry@oracle.com>
> +R:	Jason Yan <yanaijie@huawei.com>
> +L:	linux-scsi@vger.kernel.org
> +S:	Supported
> +F:	drivers/scsi/libsas
> +F:	include/scsi/libsas.h
> +F:	include/scsi/sas_ata.h
> +F:	Documentation/scsi/libsas.rst
> +
>  SCSI RDMA PROTOCOL (SRP) INITIATOR
>  M:	Bart Van Assche <bvanassche@acm.org>
>  L:	linux-rdma@vger.kernel.org

Yeah !

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

