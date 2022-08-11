Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113DBC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 19:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiHKTgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 15:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbiHKTgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 15:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B95883DC;
        Thu, 11 Aug 2022 12:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 243BF60FF4;
        Thu, 11 Aug 2022 19:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F233BC433C1;
        Thu, 11 Aug 2022 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660246578;
        bh=VFDZCqb+1IhthOrU2AnhG14PREmnKQn1Hn8rRS3DcUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mkNi12XLJTAZS+XyEUTx3wbZb+n800pOLn3zi4w7oDn90Fgquo4stiLUuU6sp6ci0
         HmOTwklaoNaROUv1m8dx8FDJD335j7uhNtpHeKIVrRUfOquQv6QKNOGbM63hSwuLrS
         EHyzROVN0masmZLkWFud3XspFRVwMLX1JWXvQSgmxxNIRGOVxvu3TLHTBeJ+EZLj4+
         srE1ZV2HL0wm2ox7EbHLp0AN0k/2hZfiXWeDyqj8TMKRHQvnCb/wuReaJNjFycXnhj
         4jDiw2xxNhf+0kjRpqO05biS4y7MPSblbwZVcJU5MpqYcOr1RTlDWMsS6sS0EpB943
         x9Qp/O0babeOA==
Date:   Thu, 11 Aug 2022 19:36:16 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniil Lunev <dlunev@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
Message-ID: <YvVaMJMPVFc4Sa+I@gmail.com>
References: <20220803074955.v6.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <YuoRuP2pxgSQ6c9E@kroah.com>
 <CAONX=-f8kHWCEEyqUdpn5wsyMZKa4eJSSCLvPDn3R5mQF9FSMA@mail.gmail.com>
 <YvSfjwCu69ivTGIZ@sol.localdomain>
 <CAONX=-dK3CA2Tp2z+HrSTrR8=VJQuiFPhgoqKQkLhrDU1JXG5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAONX=-dK3CA2Tp2z+HrSTrR8=VJQuiFPhgoqKQkLhrDU1JXG5A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 12, 2022 at 05:32:34AM +1000, Daniil Lunev wrote:
> Hi Eric,
> > This is describing the directory, so please include it in a documentation entry
> > for the directory itself (/sys/bus/platform/drivers/ufshcd/*/capabilities/) just
> > above the documentation entries for the files in the directory.
> 
> Should I keep the comment in this file as well, or remove it here when
> adding to the documentation?
> 
> --Daniil

Avoiding redundancy is nice.  Maybe make the code just refer to the
documentation?

- Eric
