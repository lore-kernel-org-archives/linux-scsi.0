Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C611C2BB55
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 11:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B50206E9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 11:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506653AbgDPLsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 07:48:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:34240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506648AbgDPLs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 07:48:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC9EDAB71;
        Thu, 16 Apr 2020 11:48:26 +0000 (UTC)
Date:   Thu, 16 Apr 2020 13:48:26 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        maier@linux.ibm.com, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 24/31] elx: efct: LIO backend interface routines
Message-ID: <20200416114826.ciphohairmyt34vt@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-25-jsmart2021@gmail.com>
 <dc132a7c-0d82-7439-dad0-c35a6acab1f7@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc132a7c-0d82-7439-dad0-c35a6acab1f7@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 11, 2020 at 09:57:45PM -0700, Bart Van Assche wrote:
> On 2020-04-11 20:32, James Smart wrote:
> > +	return EFC_SUCCESS;
> > +}
> 
> Redefining 0 is unusual in the Linux kernel. I prefer to see "return 0;"
> instead of "return ${DRIVER_NAME}_SUCCESS;".

BTW, I agree with Bart. I think we all know how to interpret 0 and
-ENOMEM etc. Adding this syntactic sugar discracts in my opinion more
than it helps. And considering that the elx driver is using both
variants in inconsistent way, I suggest to use the usual Linux kernel
style.

