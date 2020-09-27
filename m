Return-Path: <SRS0=qC8i=DE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0398DC47428
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Sep 2020 04:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDAAF239D4
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Sep 2020 04:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgI0Ewd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Sep 2020 00:52:33 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:42408 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726840AbgI0Ewd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 27 Sep 2020 00:52:33 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 382941800F757;
        Sun, 27 Sep 2020 04:52:32 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: war34_5a00deb27176
X-Filterd-Recvd-Size: 1820
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sun, 27 Sep 2020 04:52:30 +0000 (UTC)
Message-ID: <4472b9ad60cde126e2098503665dfc35f8385992.camel@perches.com>
Subject: Re: [PATCH v2 3/3] scsi: megaraid_sas: simplify compat_ioctl
 handling
From:   Joe Perches <joe@perches.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sat, 26 Sep 2020 21:52:29 -0700
In-Reply-To: <CAK8P3a01930JPMj6ie=9+GtvRQThPzxH0_ge+OWydcZd7qRkSA@mail.gmail.com>
References: <20200918120955.1465510-1-arnd@arndb.de>
         <20200918121543.1466090-1-arnd@arndb.de>
         <20200919052622.GE30063@infradead.org>
         <CAK8P3a01930JPMj6ie=9+GtvRQThPzxH0_ge+OWydcZd7qRkSA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-09-26 at 23:19 +0200, Arnd Bergmann wrote:
> On Sat, Sep 19, 2020 at 7:26 AM Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Sep 18, 2020 at 02:15:43PM +0200, Arnd Bergmann wrote:
[]
> 
> > > +     return ioc;
> > > +out:
> > > +     kfree(ioc);
> > > +
> > > +     return ERR_PTR(err);
> > 
> > spurious empty line.
> 
> ok

I suggest moving the blank line so it's between
the return ioc and out: label.


