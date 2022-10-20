Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E5EC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 09:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiJTJsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 05:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiJTJsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 05:48:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA74A1BF85D;
        Thu, 20 Oct 2022 02:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A328B826A4;
        Thu, 20 Oct 2022 09:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13C4C433C1;
        Thu, 20 Oct 2022 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666259296;
        bh=8npgO7GY2o/ILmq0ahelSxXS535Jnohswf7hgcDbm3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C+9A7e5CvRTVierBcnI1LSDYfav/OuzMBMWuxFwxBdnESEcJ3WB/YWx6ajBnBrbi5
         /0WfP0C4x69uKGYbQDRvhH1CgY13hIQ/DJl29FaCTN00Sbvd8XQJETjYQlguZz5C/v
         LQJtywJVBB5/hTuI50FGqUFNph2cWJVmor0SvIcw=
Date:   Thu, 20 Oct 2022 11:48:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cuijinpeng666@gmail.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] scsi: target: core: use strscpy() is more
 robust and safer
Message-ID: <Y1EZXcbd2iZXBkCx@kroah.com>
References: <20221020054650.394396-1-cui.jinpeng2@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020054650.394396-1-cui.jinpeng2@zte.com.cn>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 20, 2022 at 05:46:50AM +0000, cuijinpeng666@gmail.com wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>


Please ignore based on this response:
	https://lore.kernel.org/r/Y1EVnZS9BalesrC1@kroah.com

