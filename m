Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB7CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 07:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D95CB22ADC
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 07:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbhAYHam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 02:30:42 -0500
Received: from comms.puri.sm ([159.203.221.185]:35316 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727139AbhAYHaK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Jan 2021 02:30:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D1702E0FDE;
        Sun, 24 Jan 2021 23:29:25 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Y5yLFPTCRWy6; Sun, 24 Jan 2021 23:29:24 -0800 (PST)
Subject: Re: [PATCH] scsi_logging: print cdb into new line after opcode
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ewan D. Milne" <emilne@redhat.com>
Cc:     jejb@linux.ibm.com, dgilbert@interlog.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210122083918.901-1-martin.kepplinger@puri.sm>
 <c0c7b4cde76c9b15aad9fa213dcaeb75295763fd.camel@redhat.com>
 <yq1mtx09wpa.fsf@ca-mkp.ca.oracle.com>
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
Message-ID: <efab85a2-d22c-b9cb-d001-cbe09063ba5e@puri.sm>
Date:   Mon, 25 Jan 2021 08:29:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <yq1mtx09wpa.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23.01.21 04:09, Martin K. Petersen wrote:
> 
> Ewan,
> 
>>> sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00 60 40 00 00 01
>>> 00
>>>
>>> Print the cdb into a new line in any case, not only when cmd_len is
>>> greater than 16. The above example error will then read:
>>>
>>> sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28
>>> 28 00 01 c0 09 00 00 00 08 00
>>
>> I'd rather we not change this.
> 
> I agree. While the current format is suboptimal, there are lots of
> things out there parsing these error messages.
> 

hi Ewan, hi Martin,

That's totally fine. I had this on my list since Douglas suggested to 
change this during a discussion back in july and I basically wanted to 
get opinions:
https://lore.kernel.org/linux-scsi/31f1ec62-7047-a34b-fdcb-5ea2a2104292@interlog.com/

thanks,
                                  martin
