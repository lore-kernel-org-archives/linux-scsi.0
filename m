Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEAEC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 04:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344738AbiCOERC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 00:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiCOERB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 00:17:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935F4434BF;
        Mon, 14 Mar 2022 21:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C456116C;
        Tue, 15 Mar 2022 04:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49192C340E8;
        Tue, 15 Mar 2022 04:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647317620;
        bh=15p/KaVYaxWzWonuFHEiv7EQDsXjsCk3AwEGygt0bHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bUFTicAUoniRLAU9/f0cSzeehhp2Na04I2MPZ0L3rebCTUxUpFroF2D6QZm7R7eHJ
         v3q0tklAnlnSC6HlEQAOnvYGviH+YSJ3TGclYvjbM3OAT2/X+zEDpEkhIL2DRZu3YL
         Lb1+e9W+DxysjG9VyMyzx5omY0t5DjRAoyzmWBilMSh0xKm8ahUldBMMUqwdT4enis
         08Yofelc8B7uYauphm8J36UsVeix2A+LR9+E4L02dBKjoq1h0rG8xYZA5Q/8T/yKKm
         1l93EwIGKN/LMPJnrLft3YCU+AphQ9q0q8puMCNLnV5nMr9Y+G9lviJFV8tbHPmsCt
         OuxoY6GrDDN/Q==
Date:   Mon, 14 Mar 2022 23:22:23 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/8] scsi: aacraid: Replace one-element arrays with
 flexible-array members
Message-ID: <20220315042223.GA2385465@embeddedor>
References: <cover.1645513670.git.gustavoars@kernel.org>
 <20220310040347.GA2295236@embeddedor>
 <yq1h77zdg37.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1h77zdg37.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 15, 2022 at 12:02:13AM -0400, Martin K. Petersen wrote:
> 
> Gustavo,
> 
> > Friendly ping: who can review or comment on this series, please?
> 
> I'm afraid I don't have any hardware to test it on and the generated
> output differs substantially from the original code.

Yeah; this series requires careful review from the people that
knows the code better. 

It took me a day of work to go through all the places that needed
to be changed due to the flexible array transformation. However,
due to the kind of changes, it'd be great to have a second opinion
or at least someone that could take a look at the changes.

Thanks
--
Gustavo
