Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792CEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 20:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 639D2207D3
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 20:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgFCUy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 16:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgFCUy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 16:54:57 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D82C08C5C0;
        Wed,  3 Jun 2020 13:54:56 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgaPT-002fID-0a; Wed, 03 Jun 2020 20:54:51 +0000
Date:   Wed, 3 Jun 2020 21:54:50 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Don.Brace@microchip.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        don.brace@microsemi.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCHES] uaccess hpsa
Message-ID: <20200603205450.GD23230@ZenIV.linux.org.uk>
References: <20200528234025.GT23230@ZenIV.linux.org.uk>
 <20200529233923.GL23230@ZenIV.linux.org.uk>
 <SN6PR11MB2848F6299FBA22C75DF05218E1880@SN6PR11MB2848.namprd11.prod.outlook.com>
 <20200603191742.GW23230@ZenIV.linux.org.uk>
 <yq18sh398t7.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq18sh398t7.fsf@ca-mkp.ca.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 03, 2020 at 04:53:11PM -0400, Martin K. Petersen wrote:
> 
> Hi Al!
> 
> > OK...  Acked-by/Tested-by added, branch re-pushed (commits are otherwise
> > identical).  Which tree would you prefer that to go through - vfs.git,
> > scsi.git, something else?
> 
> I don't have anything queued for 5.8 for hpsa so there shouldn't be any
> conflicts if it goes through vfs.git. But I'm perfectly happy to take
> the changes through SCSI if that's your preference.

Up to you; if you need a pull request, just say so.
