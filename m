Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A14C433B4
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 14:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC9C613B2
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 14:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbhDEO10 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:27:26 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:55006 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbhDEO1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2021 10:27:25 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 12BD820F4649
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] scsi: hisi_sas: fix IRQ checks
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>
References: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <73de21af-8097-9bd3-9da4-32c9523fa148@omprussia.ru>
Date:   Mon, 5 Apr 2021 17:27:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/3/21 11:43 PM, Sergey Shtylyov wrote:

> Commit df2d8213d9e3 ("hisi_sas: use platform_get_irq()") failed to take
> into account that irq_of_parse_and_map() and platform_get_irq() have a
> different way of indicating an error: the former returns 0 and the latter
> returns a negative error code. Fix up the IRQ checks!
> 
> Fixes: df2d8213d9e3 ("hisi_sas: use platform_get_irq()")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> 
> ---

   Sorry, forgot to mention that this patch is against the 'fixes' branch of
Martin Petgersen's 'scsi.git' repo.


[...]

MBR, Sergey
