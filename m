Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A998C4727F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2579208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLzhl6Ft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgI1Uf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:35:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgI1UfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 16:35:25 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601325324;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0pAaRMLcPsQC2zisk13ceWf79SQ4euWeqjMCzzYsmF0=;
        b=HLzhl6Ft9hMpgJmz7oYY9zXmaFcsmTcBtcdBwCqcpm7Hlp8EeqRPi8TVz+EwrrCf6GLuOn
        rMQ9bQOgd+aS5PYvfA1NXnDrjOMSYtd5iIkxbKgJWARI4A+ety1rHfBgIrF3RXZL9C5nrF
        RnFpjk/kzhmGaqCo4fVzxVqwoJgp6+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-yNA4Wfm_P4y0hxZP5CDxPg-1; Mon, 28 Sep 2020 16:35:22 -0400
X-MC-Unique: yNA4Wfm_P4y0hxZP5CDxPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E57321868403;
        Mon, 28 Sep 2020 20:35:20 +0000 (UTC)
Received: from [10.10.110.11] (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ADCA5C1C4;
        Mon, 28 Sep 2020 20:35:19 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v5 07/12] libata: Make ata_scsi_durable_name static
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-8-tasleson@redhat.com>
 <ec0479bf-e5ac-58f1-248a-2d4c29ae3efa@gmail.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <b1e0f0a5-e8b3-1e11-26c5-d0b9e4d518d7@redhat.com>
Date:   Mon, 28 Sep 2020 15:35:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ec0479bf-e5ac-58f1-248a-2d4c29ae3efa@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/20 3:40 AM, Sergei Shtylyov wrote:
> 
>    Why not do it in patch #6 -- when introducing the function?

Re-working patch series, will do as you suggest and as outlined
in the submitting-patches.rst referenced by James.

Thanks

