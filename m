Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0AAC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7233E619D0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhC3RrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 13:47:10 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:50704 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhC3Rqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 13:46:49 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru B8B78207D590
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH v3 1/3: scsi: jazz_esp: add IRQ check
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <137b9e4d-391f-3163-2e6f-9e21aeb6bf34@omprussia.ru>
 <61218d82-cf49-cb75-2f54-f7a1a4e91242@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <65aa3071-e253-e65e-e1b8-1b6f47de1b15@omprussia.ru>
Date:   Tue, 30 Mar 2021 20:46:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <61218d82-cf49-cb75-2f54-f7a1a4e91242@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ignore this message -- I've lost ] in the subject. :-/
