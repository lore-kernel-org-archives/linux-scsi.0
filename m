Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DF3C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C2A964E06
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhBBLTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:19:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhBBLTj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 06:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E7964E31;
        Tue,  2 Feb 2021 11:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612264738;
        bh=YrUx7bGau1958a2cy3yc4xrRn2W1VaeQs0FQoQPA12w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ceUgFz1Xa0BCimbRZX0lM73HzKnYFjS2uZ2kNNifB7ZxnM27lD52ieTOKFRoNr52m
         u5JZ58Q8i9lRJysZLIH6JHtZ6bzCSK8yHKjn5AMyG+Q/rmZlSpVO1ichbcnhVoBJJJ
         nyDxD9gb2C68EIh2WLZeoQhjejzGT+Cq5hNygn/A=
Date:   Tue, 2 Feb 2021 12:18:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com
Subject: Re: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Message-ID: <YBk1HZijbtkMrO0O@kroah.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-10-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202083007.104050-10-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 02, 2021 at 10:30:07AM +0200, Avri Altman wrote:
> +struct attribute_group ufs_sysfs_hpb_param_group = {
> +	.name = "hpb_param_sysfs",

Shouldn't this be "hpb_param"?  Why the trailing "_sysfs", doesn't that
look odd in the directory path?

thanks,

greg k-h
