Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721C8C77B61
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Apr 2023 08:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDII7i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Apr 2023 04:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDII7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Apr 2023 04:59:37 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111F44C1B
        for <linux-scsi@vger.kernel.org>; Sun,  9 Apr 2023 01:59:36 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1plQtY-0002nQ-Ou; Sun, 09 Apr 2023 10:59:32 +0200
Message-ID: <2e585944-b34f-5df0-54e3-fba1205c4c1f@leemhuis.info>
Date:   Sun, 9 Apr 2023 10:59:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: question about mpt3sas commit b424eaa1b51c
Content-Language: en-US, de-DE
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681030776;87ca2929;
X-HE-SMSGID: 1plQtY-0002nQ-Ou
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 08.04.23 21:18, Jerry Snitselaar wrote:
> We've had some people trying to track a problem for months revolving
> around a system hanging at shutdown, and last thing they see being a
> message from mpt3sas about a reset. They quickly bisected down to the
> commit below, and reverted it made the problem go away for the
> customer.
> 
> b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")

FWIW, that should have been fae21608c31c ("scsi: mpt3sas: Transition IOC
to Ready state during shutdown") (see reply-to-self from Jerry)

> I got asked to look at something since I recently at another issue
> that involved mpt3sas at shutdown, so I was looking through the
> history, saw this commit being mentined. Looking at it, I'm not sure
> why it is doing what is doing.
> [...]

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced fae21608c31c
#regzbot title scsi: mpt3sas: systems hang at shutdown
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
