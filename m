Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DABC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 08:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4DF60FD8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 08:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhH0ILg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 04:11:36 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:48492 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231818AbhH0ILf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 04:11:35 -0400
Received: from omf07.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 1FAC38384364;
        Fri, 27 Aug 2021 08:10:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 07829315D7C;
        Fri, 27 Aug 2021 08:10:42 +0000 (UTC)
Message-ID: <4b8e2987c1ff384bac497a20fcd75f9051990cff.camel@perches.com>
Subject: Re: [PATCH 0/5] vsprintf and uses: Add upper case output to %*ph
 extension
From:   Joe Perches <joe@perches.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Date:   Fri, 27 Aug 2021 01:10:41 -0700
In-Reply-To: <YSiZlyQzgW8umsjj@smile.fi.intel.com>
References: <cover.1630003183.git.joe@perches.com>
         <YSiZlyQzgW8umsjj@smile.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: szskg1krzie8bc9fwr5cdpm3hhrjpf6c
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 07829315D7C
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19RlAkoJotf8b5Ato6PNKec4d2UgR/Nn0E=
X-HE-Tag: 1630051842-479260
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-08-27 at 10:51 +0300, Andy Shevchenko wrote:
> On Thu, Aug 26, 2021 at 11:43:00AM -0700, Joe Perches wrote:
> > Several sysfs uses that could use %*ph are upper case hex output.
> > Add a flag to the short hex formatting routine in vsprintf to support them.
> > Add documentation too.
> 
> Thanks!
> 
> Unfortunately I have got only first patch and this cover letter. Can you,
> please, Cc entire series?

It's on lore.

https://lore.kernel.org/lkml/cover.1630003183.git.joe@perches.com/T/#u
 


