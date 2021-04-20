Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2B9C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 07:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F73661057
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 07:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhDTHs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 03:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhDTHs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 03:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1BB26101E;
        Tue, 20 Apr 2021 07:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618904876;
        bh=hi94ffVEPlg1X8G3tjHc9I7JrN37STm7cFPrrJzZ9Mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NfcpuLHtdQiLP+4nzZAo/wyzAav+roBHSoxeVL++lJYm1QJiMa+GWfU68wNjiuFPb
         hNnDyarUMZhjCEbBv4LSuCFoy76e9QYOolchgYpT9qMr/6VRQitwIRC5BO6j2+s19/
         TYi8yCktPTP/eh4/8eug3tMT1FimXWoeyq/x0A8c=
Date:   Tue, 20 Apr 2021 09:47:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>
Subject: Re: [PATCH 093/117] staging: Convert to the scsi_status union
Message-ID: <YH6HKauLLpJdGqeU@kroah.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420021402.27678-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 07:13:38PM -0700, Bart Van Assche wrote:
> An explanation of the purpose of this patch is available in the patch
> "scsi: Introduce the scsi_status union".

Where is that at?

As a stand-alone-patch, this is not ok in a changelog text at all,
sorry, and I can not take this.

greg k-h
