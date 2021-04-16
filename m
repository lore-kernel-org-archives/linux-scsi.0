Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3504DC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 19:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C2F613C1
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 19:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240473AbhDPTgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 15:36:53 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:39298 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhDPTgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 15:36:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 6BB5C9FF93;
        Fri, 16 Apr 2021 19:36:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id z-62OPgm7yLF; Fri, 16 Apr 2021 19:36:26 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 7EE49A1459;
        Fri, 16 Apr 2021 19:36:19 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id A77CE3EE4F;
        Fri, 16 Apr 2021 13:36:18 -0600 (MDT)
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org>
Date:   Fri, 16 Apr 2021 13:36:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/14/21 4:38 PM, Maciej W. Rozycki wrote:
> Hi,
> 
>  First of all, does anyone have a copy of: "MultiMaster UltraSCSI Host 
> Adapters for PCI Systems: Technical Reference Manual" (pub. 3002493-E)?  
> It used to live in the "Mylex Manuals and Documentation Archives" section 
> of the Mylex web site <http://www.mylex.com/pub/manuals/index.htm>, 
> specifically at: <http://www.mylex.com/pub/manuals/mmultra.pdf>.
> 
>  Another useful document might be: "Wide SCSI Host Adapters for PCI and 
> EISA Systems: Technical Reference Manual" (pub. 3000763-A), which used to 
> live at: <http://www.mylex.com/pub/manuals/widescsi.pdf>, linked from the 
> same place.
> 
>  Sadly I didn't get to these resources while they were still there, and 
> neither did archive.org, and now they not appear available from anywhere 
> online.  I'm sure Leonard had this all, but, alas, he is long gone too.

These documents were all gone by the time I started working on this
driver in 2013.

--
Khalid


