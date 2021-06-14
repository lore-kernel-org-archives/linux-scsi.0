Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEACC2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 22:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3CB61185
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 22:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFNWJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 18:09:29 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:50845 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhFNWJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 18:09:28 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 2287C2EA47F;
        Mon, 14 Jun 2021 18:07:25 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id NBQX_U7RjRst; Mon, 14 Jun 2021 18:07:24 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id BA7CB2EA00E;
        Mon, 14 Jun 2021 18:07:24 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 09/15] scsi: scsi_debug: Improve RDPROTECT/WRPROTECT
 handling
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-10-martin.petersen@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <01c800ca-eeed-60d3-012a-4b4dd7cbf31b@interlog.com>
Date:   Mon, 14 Jun 2021 18:07:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210609033929.3815-10-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-08 11:39 p.m., Martin K. Petersen wrote:
> It is useful for testing purposes to be able to inject errors by
> writing bad protection information to media with checking disabled and
> then attempting to read it back. Extend scsi_debug's PI verification
> logic to give the driver feature parity with commercially available
> drives. Almost all devices with PI capability support RDPROTECT and
> WRPROTECT values of 0, 1, and 3.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>


