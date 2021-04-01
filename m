Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE07C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DED9610CB
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhDAH3U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:29:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:44132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhDAH3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Apr 2021 03:29:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2A9A5AF5A;
        Thu,  1 Apr 2021 07:29:03 +0000 (UTC)
To:     dgilbert@interlog.com, "Ewan D. Milne" <emilne@redhat.com>,
        linux-scsi@vger.kernel.org
References: <20210331201154.20348-1-emilne@redhat.com>
 <2c505c60-9ba0-9ce6-46a6-e6edea2ada03@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: remove check for ASC 24h when
 ILLEGAL_REQUEST returned on RTPG w/extended header
Message-ID: <a7bbfb39-653e-29d9-f7f8-acf37c2e9b1d@suse.de>
Date:   Thu, 1 Apr 2021 09:29:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <2c505c60-9ba0-9ce6-46a6-e6edea2ada03@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/21 6:24 AM, Douglas Gilbert wrote:
> On 2021-03-31 4:11 p.m., Ewan D. Milne wrote:
>> Some arrays return ILLEGAL_REQUEST with ASC 00h if they don't support the
>> extended header, so remove the check for INVALID FIELD IN CDB.
> 
> Wow. Referring to the 18 byte sense buffer as an extended header sounds
> like it comes from the transition of SCSI-1 to SCSI-2, about 30 years ago.
> Those arrays need to be named and shamed.
> 
> Doug Gilbert
> Hmm, it is April first ...
> 

Hey, it took us some time to even _get_ this header; originally
the specification didn't have that, requiring us to second-guess how
long the array might take for a transition.

But still, April the first :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
