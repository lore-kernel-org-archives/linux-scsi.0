Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED33C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 18:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A9E064F60
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 18:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhCLS2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:28:05 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:59745 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhCLS1q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 13:27:46 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 72F272EA008;
        Fri, 12 Mar 2021 13:27:45 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 0ToYNGiW4lqh; Fri, 12 Mar 2021 13:10:39 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 2D4CA2EA305;
        Fri, 12 Mar 2021 13:27:45 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [bug report] scsi: sg: NO_DXFER move to/from kernel buffers
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Colin King <colin.king@canonical.com>
References: <YEsbkuW/CoaDxl0L@mwanda>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <dd80e8a9-cb24-a965-0719-1dbe134d18a8@interlog.com>
Date:   Fri, 12 Mar 2021 13:27:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YEsbkuW/CoaDxl0L@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-12 2:43 a.m., Dan Carpenter wrote:
> Hello Douglas Gilbert,
> 
> The patch b32ac463cb59: "scsi: sg: NO_DXFER move to/from kernel
> buffers" from Feb 19, 2021, leads to the following static checker
> warning:
> 
> 	drivers/scsi/sg.c:2990 sg_rq_map_kern()
> 	error: uninitialized symbol 'k'.

Hello,
These reports were made by Colin King yesterday and patches have already
been issued.

Doug Gilbert
