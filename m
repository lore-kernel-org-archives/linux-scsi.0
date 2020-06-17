Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81315C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69735212CC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgFQIsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:48:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:59810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgFQIsN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 04:48:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA738AC9F;
        Wed, 17 Jun 2020 08:48:16 +0000 (UTC)
Subject: Re: [PATCH 1/4] gdth: reindent and whitespace cleanup
From:   Hannes Reinecke <hare@suse.de>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200616121821.99113-1-hare@suse.de>
 <20200616121821.99113-2-hare@suse.de>
 <20200617082145.mdsu56bclo3p3dg4@beryllium.lan>
 <2a7473b3-62af-f7d2-f73a-adcabe21701e@suse.de>
Message-ID: <72827be0-a44a-0163-acb8-04ff3bde86ce@suse.de>
Date:   Wed, 17 Jun 2020 10:48:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <2a7473b3-62af-f7d2-f73a-adcabe21701e@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/17/20 10:34 AM, Hannes Reinecke wrote:
> On 6/17/20 10:21 AM, Daniel Wagner wrote:
>> On Tue, Jun 16, 2020 at 02:18:18PM +0200, Hannes Reinecke wrote:
>>> Long overdue. No functional change.
>>
>> Did you test if compiler generates the same output? I don't think anyone
>> wants to review this patch :)
>>
> Hmm. No. Lemme check what happens...
> 
Phew. Just checked, and the disassembly is indeed identical.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
