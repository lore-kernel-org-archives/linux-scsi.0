Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D89C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 01:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8163120848
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 01:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgH1BLK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 21:11:10 -0400
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:36728 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgH1BLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 21:11:09 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B49D2181D3025;
        Fri, 28 Aug 2020 01:11:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: can98_270b1e627071
X-Filterd-Recvd-Size: 1791
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 28 Aug 2020 01:11:03 +0000 (UTC)
Message-ID: <32f16bf6137f8575f2b1d66258d77269ce0f9d28.camel@perches.com>
Subject: Re: [PATCH 17/19] z2ram: reindent
From:   Joe Perches <joe@perches.com>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Date:   Thu, 27 Aug 2020 18:11:02 -0700
In-Reply-To: <alpine.LNX.2.23.453.2008281052580.8@nippy.intranet>
References: <8570915f668159f93ba2eb845a3bbc05f8ee3a99.camel@perches.com>
                 <EF673A30-F88D-4E4E-8A2B-E942153830AC@physik.fu-berlin.de>
                 <b88538f92386f41b938c502ae2daec5800a85dcf.camel@perches.com>
                 <alpine.LNX.2.23.453.2008280859300.10@nippy.intranet>
         <5682daf68b94be288c05f859942ce06deec2b022.camel@perches.com>
         <alpine.LNX.2.23.453.2008281052580.8@nippy.intranet>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-08-28 at 10:57 +1000, Finn Thain wrote:
> On Thu, 27 Aug 2020, Joe Perches wrote:
> 
> > checkpatch already does this.
> > 
> 
> Did you use checkpatch to generate this patch?

Nope.

