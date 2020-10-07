Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EA1C3279D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12279207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgJGDLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:11:15 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:41717 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgJGDLP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:11:15 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 23:11:14 EDT
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 9DE072EAB94;
        Tue,  6 Oct 2020 23:03:28 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id OMOt7DqS9VdY; Tue,  6 Oct 2020 22:56:50 -0400 (EDT)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id E8D662EAB88;
        Tue,  6 Oct 2020 23:03:27 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH V2 0/4] pm80xx updates.
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Ruksar.devadi@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20201005145011.23674-1-Viswas.G@microchip.com.com>
 <yq1r1qa7pw7.fsf@ca-mkp.ca.oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <81c98e02-75cf-5f9d-612f-a67a374811c3@interlog.com>
Date:   Tue, 6 Oct 2020 23:03:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <yq1r1qa7pw7.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-06 10:06 p.m., Martin K. Petersen wrote:
> 
> Viswas,
> 
>> Changes from v1:
>> 	- Improved commit messages.
>> 	- Fixed compiler warning for
>> 		 "Increase the number of outstanding IO supported" patch
> 
> Applied to 5.10/scsi-staging.
> 
> In the future please run checkpatch and make sure that the commit
> messages are using imperative mood (see
> Documentation/process/submitting-patches.rst, section 2).

Get thee to a nunnery! [W. Shakespeare; translation: "fuck off"]
Now that is imperative.

As for "imperative mood", I believe there is no such thing in English
grammar. My mother taught grammar and I studied French and Latin at
school. Markus Elfring objected to my:
     [PATCH] lib/scatterlist: Fix memory leak in sgl_alloc_order()  ***

with the same "imperative mood" line. In English, including British
(i.e. "international") English taught in south Asia, that is the
_imperative_ . Basically if you can stick "You" in front of the
verb at the start of the sentence and the sense is the same, then
it is the imperative.

Is the "imperative mood" something in Danish or German grammar?

Doug Gilbert


*** That patch was ack-ed by Bart (the culprit) and as far as I
     know hasn't gone any further. My sgl-to-sgl copy, compare
     and sgl_memset await that bug being sorted.

