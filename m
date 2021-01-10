Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F18C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD2322B3A
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbhAJQwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:52:02 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:33786 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAJQwC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 11:52:02 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2021 11:52:01 EST
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru C015220A83B2
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH 0/3] Improve comments in Adaptec AHA-154x driver
Organization: Open Mobile Platform, LLC
Message-ID: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Date:   Sun, 10 Jan 2021 19:45:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Here are 3 patches against the 'for-next' branch of Martin Petersen's 'scsi.git' repo.
I'm trying to clean up and improve the driver comments...

[1/3] aha1542: clarify 'struct ccb' comments
[2/3] aha1542: kill trailing whitespace
[3/3] aha1542: fix multi-line comment style
