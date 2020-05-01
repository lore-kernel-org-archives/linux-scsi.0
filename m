Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8152FC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 20:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514A6208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 20:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VR/8hEsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgEAU4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 16:56:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726318AbgEAU4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 16:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588366594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=feZvcvjvjuwjs6NSAyIML+aY3mjtHkgI8MsqkvYUe3U=;
        b=VR/8hEsXbvjEcNQWOgrUSahYXT/OxJgWlOXbAOfVAg9dI8WEogFvMFA83pUaevsUzGnj6h
        cSsUUk0UwgwFYaJ0qefZh8E+/id1iRCqZEtgouyCppbVITzuI5ENxfYgCqIcF/kxI3MFQR
        SMOSdReGPMySD2zaUavVIaVZJZwDjpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-tJNGTaEMMfirhEM2XG47ww-1; Fri, 01 May 2020 16:56:31 -0400
X-MC-Unique: tJNGTaEMMfirhEM2XG47ww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7B7245F;
        Fri,  1 May 2020 20:56:29 +0000 (UTC)
Received: from [10.10.113.244] (ovpn-113-244.rdu2.redhat.com [10.10.113.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C7D15EE10;
        Fri,  1 May 2020 20:56:28 +0000 (UTC)
Subject: Re: [PATCH 0/4] target: tcmu: allow flexible pr and alua handling
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     ddiss@suse.de, hch@lst.de, martin.petersen@oracle.com
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <a82906f3-c671-22fd-7722-1df5eb02b1f8@redhat.com>
Date:   Fri, 1 May 2020 15:56:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/20 10:08 AM, Bodo Stroesser wrote:
> These patches already were sent to target-devel only. So I'm resending
> them now, slightly modified according to review comments from
> target-devel.
> 
> The goal of the patches is to add more flexibility to tcmu regarding
> PGR handling.
> 
> Since the attribute emulate_pr is missing for pscsi in the same way as
> for tcmu, I'm adding it to pscsi also. 
>

It looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

