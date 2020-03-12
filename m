Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBAFC2BB1D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 10:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D533820674
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 10:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCLKVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:21:43 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:42982 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725268AbgCLKVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 06:21:43 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 5C1362C94;
        Thu, 12 Mar 2020 10:21:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: thumb39_48ee4dd62f451
X-Filterd-Recvd-Size: 1674
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu, 12 Mar 2020 10:21:41 +0000 (UTC)
Message-ID: <81bad451e9ffee6990ffc3571bc7b558c1c26bb3.camel@perches.com>
Subject: Re: [PATCH -next 006/491] ARM/RISCPC ARCHITECTURE: Use fallthrough;
From:   Joe Perches <joe@perches.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date:   Thu, 12 Mar 2020 03:19:57 -0700
In-Reply-To: <20200312101130.GX25745@shell.armlinux.org.uk>
References: <cover.1583896344.git.joe@perches.com>
         <fb956ff22b89ac7a7f97489b29ecf13a32de8d06.1583896348.git.joe@perches.com>
         <20200312101130.GX25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-03-12 at 10:11 +0000, Russell King - ARM Linux admin wrote:
> On Tue, Mar 10, 2020 at 09:51:20PM -0700, Joe Perches wrote:
> > Convert the various uses of fallthrough comments to fallthrough;
> 
> And the point of what on the face of it seems to be useless churn is?
> 
> What compilers support this?

gcc 7.1, clang 9

clang does not support the /* fallthrough */ comment styles.

clang does support the __attribute__((__fallthrough__))
and the c++17 [[fallthrough]] weirdness.

see:

commit 294f69e662d1 ("compiler_attributes.h: Add 'fallthrough' pseudo
keyword for switch/case use")

