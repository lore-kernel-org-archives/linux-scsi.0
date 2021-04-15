Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B737C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21A461249
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhDOMvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:51:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232223AbhDOMvI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 08:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618491045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qHFfNEhqMxtYScmgjdaVRmQhSRg27nNMsoXSPLTiaLE=;
        b=UyLRtPm+A0QlfTVX6/Gm47fW6PGdWN923griPxKBzlxdsqMRlJlPzoVceWZriMi/sLwvwA
        v4EIksKEuqCj5lQJvI62oW4YymLFG8/siGcP2I3Y8xm9REDZlBGgDlbjE9IWiu+Bquw87s
        /B3F/2qQtjFGvcysWav0OlJUSpC1dLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-07QEiLX9NpOretFpS2hC5g-1; Thu, 15 Apr 2021 08:50:43 -0400
X-MC-Unique: 07QEiLX9NpOretFpS2hC5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A32B3107ACCA;
        Thu, 15 Apr 2021 12:50:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF28B5C3F8;
        Thu, 15 Apr 2021 12:50:41 +0000 (UTC)
Subject: Re: [PATCH v2 23/24] mpi3mr: add eedp dif dix support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-24-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <3875171d-1960-1209-986e-117d738de664@redhat.com>
Date:   Thu, 15 Apr 2021 14:50:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-24-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

