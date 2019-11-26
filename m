Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C47C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 15:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F8E820678
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 15:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JbSXPA51"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfKZP2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 10:28:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38210 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfKZP2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 10:28:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574782131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FlKN8fXlA2xNoBEu4Rm4UB1i0dvQjMc3ebopuyKlHP0=;
        b=JbSXPA51hsdgsCqEsCnwUBWiz+I1YZ/OINk2Ht1aDnfIUHp3/vHEl0mIvWhQ2SYxD+2stk
        +tY1L4j7+VaE3l6oU5bP5RBrAOnfYJHZJcZpVaZ3NDXZZNtMfeyBwui7XKOLL0HUv805jF
        hLtCAJju/nIg8keWXR5ear/dFX40U/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-b5cT7PpEP5WIXnHXSTRX_w-1; Tue, 26 Nov 2019 10:28:48 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 133A418764E8;
        Tue, 26 Nov 2019 15:28:47 +0000 (UTC)
Received: from [10.40.204.111] (ovpn-204-111.brq.redhat.com [10.40.204.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDBEC19C69;
        Tue, 26 Nov 2019 15:28:45 +0000 (UTC)
Subject: Re: [PATCH] scsi_debug: check if the max_queue parameter is valid
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20191119154059.9440-1-mlombard@redhat.com>
 <yq1d0dnfd3l.fsf@oracle.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        dgilbert@interlog.com
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <1d17ea0d-0e99-cd0a-c084-ad5e9f16a3be@redhat.com>
Date:   Tue, 26 Nov 2019 16:28:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.0
MIME-Version: 1.0
In-Reply-To: <yq1d0dnfd3l.fsf@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: b5cT7PpEP5WIXnHXSTRX_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin!

Dne 20.11.2019 v 04:20 Martin K. Petersen napsal(a):
> 
> Instead of dealing with each of these parameters individually, maybe it
> would be a good idea to go through all the int parameters and identify
> the ones that really should be unsigned? And then tweak their input
> validators accordingly.
> 


Ok I will go through the parameters and convert them to unsigned where it makes sense.

Maurizio

