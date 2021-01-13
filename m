Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54750C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 04:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D79523133
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 04:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbhAMEX5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 23:23:57 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:61002 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbhAMEX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 23:23:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610511816; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=WofGqsb0VTm5lUhkM91V8uG/rpLV33huUtTHgpplmwA=;
 b=mOJpJbhCPykFEVGtkBtDFEbVR8pEwpb8PbvoG1cf8PPn4wCY2RWEN12AMbgfe8q1nNA0WD2j
 ZiVgr734zy5cb9Hc1T3vgQaCgHCsyaXWgDjezFjhk4/fy/uUXonC+4XJVxxUEZLepfKRKRXE
 KUF0ie1J1qtHVq335H16cU9BDK4=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5ffe75ade53eb5da8cccb8ce (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 13 Jan 2021 04:23:09
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2CDA2C433C6; Wed, 13 Jan 2021 04:23:09 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2834FC433CA;
        Wed, 13 Jan 2021 04:23:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 Jan 2021 12:23:08 +0800
From:   Can Guo <cang@codeaurora.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v3 0/2] Synchronize user layer access with system PM ops
 and error handling
In-Reply-To: <yq1bldt4gis.fsf@ca-mkp.ca.oracle.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
 <yq1bldt4gis.fsf@ca-mkp.ca.oracle.com>
Message-ID: <b547a67134b0f207ae0d407841178581@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-13 12:18, Martin K. Petersen wrote:
> Can,
> 
>> This series contains two changes and it is based on 5.11/scsi-queue
> 
> Please rebase against 5.12/scsi-queue.
> 
> Thanks!

Sure. Thanks Martin.
