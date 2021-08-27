Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1B5C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 16:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEA960F92
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 16:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245344AbhH0QK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 12:10:29 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:46702 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245348AbhH0QK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 12:10:27 -0400
Received: from omf08.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 3381E182CF665;
        Fri, 27 Aug 2021 16:09:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id D46641A29F9;
        Fri, 27 Aug 2021 16:09:33 +0000 (UTC)
Message-ID: <628285fc7757f020159503d4d3b45790e73f0133.camel@perches.com>
Subject: Re: [PATCH 0/5] vsprintf and uses: Add upper case output to %*ph
 extension
From:   Joe Perches <joe@perches.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Date:   Fri, 27 Aug 2021 09:09:32 -0700
In-Reply-To: <YSi9NufNS18rRpmE@kroah.com>
References: <cover.1630003183.git.joe@perches.com>
         <YSiZlyQzgW8umsjj@smile.fi.intel.com>
         <4b8e2987c1ff384bac497a20fcd75f9051990cff.camel@perches.com>
         <YSimXPUVcy9zhpYG@smile.fi.intel.com> <YSi9NufNS18rRpmE@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aby4s94qy84u5x9x6aqguca3q11mh8d3
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: D46641A29F9
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18E1EtdtIkXuy4sqiURYIDYh0DNlDpJ/ag=
X-HE-Tag: 1630080573-979598
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-08-27 at 12:23 +0200, Greg KH wrote:
> On Fri, Aug 27, 2021 at 11:46:20AM +0300, Andy Shevchenko wrote:
> > On Fri, Aug 27, 2021 at 01:10:41AM -0700, Joe Perches wrote:
> > > On Fri, 2021-08-27 at 10:51 +0300, Andy Shevchenko wrote:
> > > > On Thu, Aug 26, 2021 at 11:43:00AM -0700, Joe Perches wrote:
> > > > > Several sysfs uses that could use %*ph are upper case hex output.
> > > > > Add a flag to the short hex formatting routine in vsprintf to support them.
> > > > > Add documentation too.
> > > > 
> > > > Thanks!
> > > > 
> > > > Unfortunately I have got only first patch and this cover letter. Can you,
> > > > please, Cc entire series?
> > > 
> > > It's on lore.
> > > 
> > > https://lore.kernel.org/lkml/cover.1630003183.git.joe@perches.com/T/#u
> > 
> > Thanks. So, you won't me to review them in a regular way :-)
> > 
> > TBH, I think those examples may pretty much be safe to use small
> > letters always.
> 
> I agree, let's just fix the users here to use small letters instead of
> adding another modifier to the kernel.

ABI _should_ mean stability for random parsers.

I don't use these so I don't care that much.

