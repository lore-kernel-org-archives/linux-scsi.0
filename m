Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1841C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 04:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbiCDEEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 23:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237839AbiCDEE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 23:04:26 -0500
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E429F7A98A
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 20:03:37 -0800 (PST)
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay01.hostedemail.com (Postfix) with ESMTP id 608BC60B54;
        Fri,  4 Mar 2022 04:03:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 478FA20033;
        Fri,  4 Mar 2022 04:03:32 +0000 (UTC)
Message-ID: <7368bc3ea6dece01004c3e0c194abb0d26d4932b.camel@perches.com>
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
From:   Joe Perches <joe@perches.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Finn Thain <fthain@linux-m68k.org>
Cc:     Konrad Wilhelm Kleine <kkleine@redhat.com>,
        Tom Rix <trix@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        megaraidlinux.pdl@broadcom.com, scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
In-Reply-To: <CANiq72kOJh_rGg6cT+S833HYqwHnZJzZss8v+kQDcgz_cZUfBQ@mail.gmail.com>
References: <20220127151945.1244439-1-trix@redhat.com>
         <d26d4bd8-b5e1-f4d5-b563-9bc4dd384ff8@acm.org>
         <0adde369-3fd7-3608-594c-d199cce3c936@redhat.com>
         <e3ae392a16491b9ddeb1f0b2b74fdf05628b1996.camel@perches.com>
         <46441b86-1d19-5eb4-0013-db1c63a9b0a5@redhat.com>
         <8dd05afd-0bb9-c91b-6393-aff69f1363e1@redhat.com>
         <233660d0-1dee-7d80-1581-2e6845bf7689@linux-m68k.org>
         <CABRYuGk+1AGpvfkR7=LTCm+bN4kt55fwQnQXCjidSXWxuMWsiQ@mail.gmail.com>
         <95f5be1d-f5f3-478-5ccb-76556a41de78@linux-m68k.org>
         <CANiq72kOJh_rGg6cT+S833HYqwHnZJzZss8v+kQDcgz_cZUfBQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Date:   Thu, 03 Mar 2022 15:38:27 -0800
User-Agent: Evolution 3.40.4-1ubuntu2 
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 478FA20033
X-Stat-Signature: yz18ifsua7kdmzp74w4prbz8mu3wc8q6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18oUcfg3lbyw2FPCUH8mnKyjJijBMjDisc=
X-HE-Tag: 1646366612-611934
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-03-04 at 00:17 +0100, Miguel Ojeda wrote:
> On Thu, Mar 3, 2022 at 11:44 PM Finn Thain <fthain@linux-m68k.org> wrote:
> > 
> > Others might argue that they should always be changed from,
> > 
> > /*
> >  * this style
> >  * of multiline comment
> >  */
> > 
> > to
> > 
> > /* this style
> >  * of multiline comment
> >  */
> 
> In general, for things that the coding style guide talks about, we
> should follow them, even if some subsystems do not (they can always
> override in their folder if they really, really want it). So, here for
> instance, the first one should be used.

It's up to individual maintainers to each decide on what might be
considered unnecessary churn for the subsystems they control.

One argument is that churn leads to difficulty in backporting
fixes to older 'stable' versions.

I think the churn argument is overstated.


