Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CA3C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 19:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4A0861104
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 19:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhDHTYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 15:24:13 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:56320 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhDHTYM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 15:24:12 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 708072EA0E6;
        Thu,  8 Apr 2021 15:23:59 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 4qWOmxGH6Iwk; Thu,  8 Apr 2021 15:05:05 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id F2DE72EA0D8;
        Thu,  8 Apr 2021 15:23:58 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [Announce] sg3_utils-1.46 available
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
        Martin Pitt <mpitt@debian.org>, Hannes Reinecke <hare@suse.de>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>
References: <c54c62ff-33fd-267f-6828-4636e9968cf4@interlog.com>
Message-ID: <bfe22599-8659-f719-1044-3ed016e51ce4@interlog.com>
Date:   Thu, 8 Apr 2021 15:23:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c54c62ff-33fd-267f-6828-4636e9968cf4@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-29 10:04 p.m., Douglas Gilbert wrote:
> sg3_utils is a package of command line utilities for sending SCSI commands
> to storage devices. It some contexts it can send ATA and NVMe commands.
> The package targets the Linux 5, 4, 3, 2.6 and 2.4 kernel series. It has
> ports to FreeBSD, Android, Solaris, and Windows (cygwin and MinGW).
> 
> For an overview of sg3_utils and downloads see either of these pages:
>      http://sg.danny.cz/sg/sg3_utils.html
    https://sg.danny.cz/sg/sg3_utils.html

>      https://doug-gilbert.github.io/sg3_utils.html
> The sg_ses utility (for enclosure devices) is discussed at:
>      http://sg.danny.cz/sg/sg_ses.html
    https://sg.danny.cz/sg/sg3_utils.html

> A full changelog can be found at:
>      http://sg.danny.cz/sg/p/sg3_utils.ChangeLog
    https://sg.danny.cz/sg/p/sg3_utils.ChangeLog

>      https://doug-gilbert.github.io/p/sg3_utils.ChangeLog
> This github mirror needs to be updated:
>      https://github.com/hreinecke/sg3_utils
> Plus the author's own github mirror:
>      https://github.com/doug-gilbert/sg3_utils
> 

The danny.cz site now support https :-)

Doug Gilbert
