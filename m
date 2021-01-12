Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C12C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD9F5230FC
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbhALQhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:37:43 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:41268 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhALQhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 11:37:43 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru B3A082341DBE
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 0/3] Improve comments in Adaptec AHA-154x driver
To:     <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Ondrej Zary <linux@zary.sk>
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
 <b2a24db42b66ffbc6a9a39bf36ed31875795ae31.camel@linux.ibm.com>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <7e226e87-5803-e025-c5ac-8747fcf30e81@omprussia.ru>
Date:   Tue, 12 Jan 2021 19:36:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b2a24db42b66ffbc6a9a39bf36ed31875795ae31.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/21 7:09 PM, James Bottomley wrote:

>> Here are 3 patches against the 'for-next' branch of Martin Petersen's
>> 'scsi.git' repo. I'm trying to clean up and improve the driver comments...
> 
> Do you actually have one of these?  The last known working one was

   Unfortunately, no (I used to play with AHA-154x back in the 90s :-).
   Only have some NCR 5380 cards and 53C810, have the _paper_ manuals for those.. :-)

> owned by Ondrej Zary (added to cc).  Since they're ISA only and that
> hardware is pretty much dead, this class of drivers might be a good
> candidate for removal.

   I saw some recent patch activity with this driver and thought it's still supported...

> James

MBR, Sergei
