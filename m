Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDBEC678D5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 19:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCDTpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Mar 2023 14:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDTpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2023 14:45:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41BEC67F
        for <linux-scsi@vger.kernel.org>; Sat,  4 Mar 2023 11:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=UdYkt2Js6Bp2OFGPw5jM465PX5HmLSzClCA+FVI5Mrc=; b=u7sPdlKU9Gs3R9qIYylSwisHBI
        3jnOANnQu02qZkDcXjATxCVWGIPrAMh3j5kvzhfeqYt7YY8ri0ZV9YT375cKWNEx7h+ubz127VLCz
        V+kk3WDJoh5nm/KuFI4EcTADnn1GUptSwBqmfw6lHIHNAFVoQyLmBPd/ys9Ah31OxirmbtxUTgdhn
        r95h4fR87UOFVlc7Oe7X0gVfnI8PARjsCYhHbwh2Hs2H8MBIxiZkfrtHCodh1cRxB1nD57inGYx1k
        RadQa1ByKUtxOP7BnJqau54SODisCYQLdYCuPGFKFtEe374nU8vSu3eYLKnScwCm1nbtZAE70T5dF
        VY+QOqZQ==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pYXoK-0040Tk-Bb; Sat, 04 Mar 2023 19:44:53 +0000
Message-ID: <8a70e31f-8f3d-90cb-ebfc-e0f9d5a3cf34@infradead.org>
Date:   Sat, 4 Mar 2023 11:44:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 65/81] scsi: ps3rom: Declare SCSI host template const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-66-bvanassche@acm.org>
From:   Geoff Levand <geoff@infradead.org>
In-Reply-To: <20230304003103.2572793-66-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 3/3/23 16:30, Bart Van Assche wrote:
> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ps3rom.c | 2 +-

I rebased the current ps3-queue branch of my kernel.org ps3-linux.git repo
on top of your scsi-const-host-template branch and tested on PS3.  I could
mount and read a disk in the CD-ROM drive (the ps3rom device).

Thanks for your efforts.

Tested-by: Geoff Levand <geoff@infradead.org>


