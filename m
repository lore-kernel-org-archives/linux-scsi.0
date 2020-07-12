Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CB1C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1DE2063A
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgGLSsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 14:48:10 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50642 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgGLSsJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jul 2020 14:48:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id AB2A7204255;
        Sun, 12 Jul 2020 20:48:06 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NmwtJc7wgLcl; Sun, 12 Jul 2020 20:48:00 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id D88F1204164;
        Sun, 12 Jul 2020 20:47:59 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 2/2] scsi_debug: update documentation url and bump version
To:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de,
        =?UTF-8?Q?Dan_Hor=c3=a1k?= <dhorak@redhat.com>
References: <20200712182927.72044-1-dgilbert@interlog.com>
 <20200712182927.72044-3-dgilbert@interlog.com>
 <1594579379.3446.23.camel@linux.vnet.ibm.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <cf7adf87-19b9-305a-0714-926d45fe5ba4@interlog.com>
Date:   Sun, 12 Jul 2020 14:47:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594579379.3446.23.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-12 2:42 p.m., James Bottomley wrote:
> On Sun, 2020-07-12 at 14:29 -0400, Douglas Gilbert wrote:
> [...]
>> - *  For documentation see http://sg.danny.cz/sg/sdebug26.html
>> + *  For documentation see http://sg.danny.cz/sg/scsi_debug.html
> 
> If you're doing this, what about asking danny for a https URL to at
> least prevent pointless churn around this file?

James,
I have asked multiple times about that upgrade (i.e. http --> https).
Still waiting.

Doug Gilbert
