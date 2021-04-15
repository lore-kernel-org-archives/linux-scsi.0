Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814EEC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461D961139
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhDOMrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:47:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230487AbhDOMrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 08:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618490801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hAriGPM2C/xSxtT+9yCU3iKlrf8DQ01fX1GBIjIqeM=;
        b=ZLJi11oxAz6qgPUeAEE/5dsQbuDZUFGrNsaeag+UPTpvhA7P2wHu0IZtIXnOEGc2DlGuvM
        mFkKa53JmZcLMjhUkSdQ6kQ9oxXtNjMgYTWVLH2+xPeSa6/PJT9m4nB3Bp175ifBnQM7Ob
        OlasiGJdBmRQI7u4issEO5wDwgrOsbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-WNgh02fcPlaTL9xiOMJxHw-1; Thu, 15 Apr 2021 08:46:40 -0400
X-MC-Unique: WNgh02fcPlaTL9xiOMJxHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25A78107ACE4;
        Thu, 15 Apr 2021 12:46:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72B885D9C0;
        Thu, 15 Apr 2021 12:46:38 +0000 (UTC)
Subject: Re: [PATCH v2 21/24] mpi3mr: add support of PM suspend and resume
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-22-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <192c8449-f27a-8c02-2463-4336650f4090@redhat.com>
Date:   Thu, 15 Apr 2021 14:46:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-22-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
Looks good



Reviewed-by: Tomas Henzl <thenzl@redhat.com>

