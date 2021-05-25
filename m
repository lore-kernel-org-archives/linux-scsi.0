Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62B7C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 14:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B27656142B
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 14:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhEYOop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 10:44:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234079AbhEYOon (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 10:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621953793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2eREcQH05HdMm07P16cGEvnLmqZIHH3Z/hvbRfIzcmM=;
        b=EQAG/Ry/WbhGNsry8FgV6Wk+QSFQnigRinHK3fu+zI7JAUqKarERJbBngsS7dAYKXrWcWz
        xI3qpOYS5OGfCNUPXMxN2g3tHR+U+WealWB9u2DeKT5KEpAhiOfEcJqYcjbd67YF9Q5Dfa
        EbZWvakw8OvEvhJbCdh1qidcFL4Upc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-NtxLsyiQOXKCkKQ3yL5EEg-1; Tue, 25 May 2021 10:43:09 -0400
X-MC-Unique: NtxLsyiQOXKCkKQ3yL5EEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C23718049C5;
        Tue, 25 May 2021 14:43:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C3105D6AC;
        Tue, 25 May 2021 14:43:05 +0000 (UTC)
Subject: Re: [PATCH v6 13/24] mpi3mr: implement scsi error handler hooks
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com,
        hare@suse.de
References: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
 <20210520152545.2710479-14-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <415d8bcd-71eb-4265-ca51-146a55cfd92d@redhat.com>
Date:   Tue, 25 May 2021 16:43:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210520152545.2710479-14-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/21 5:25 PM, Kashyap Desai wrote:
> SCSI EH hook is added.
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Cc: sathya.prakash@broadcom.com
> Cc: hare@suse.de
> Cc: thenzl@redhat.com

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Regards,
Tomas

