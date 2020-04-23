Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E50C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966F421569
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDWIFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 04:05:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:48010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgDWIFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 04:05:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 29EAEAB64;
        Thu, 23 Apr 2020 08:05:08 +0000 (UTC)
Date:   Thu, 23 Apr 2020 10:05:08 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 14/31] elx: libefc: FC node ELS and state handling
Message-ID: <20200423080508.jy7rwu4jumcxbkhx@beryllium.lan>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-15-jsmart2021@gmail.com>
 <20200415185603.hoaap564jde4v6bt@carbon>
 <d18094a8-32c2-f024-db46-7cec0cd21754@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18094a8-32c2-f024-db46-7cec0cd21754@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Wed, Apr 22, 2020 at 07:50:06PM -0700, James Smart wrote:
> On 4/15/2020 11:56 AM, Daniel Wagner wrote:
> ...
> > > +	switch (evt) {
> > > +	case EFC_EVT_ENTER:
> > > +		efc_node_hold_frames(node);
> > > +		/* Fall through */
> > 
> > 		fallthrough;
> > 
> 
> Actually the patches that went in for -Wimplicit-fallthrough wants
> /* fall through */

Ah okay, I though the fall through rules are active. Anyway, I am sure
someone will run a script to report when to change.

Thanks,
Daniel
