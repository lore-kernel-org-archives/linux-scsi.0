Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6DDC001DD
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 13:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbjGMNLk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 09:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbjGMNL3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 09:11:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE60B2706;
        Thu, 13 Jul 2023 06:11:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39A1E1576;
        Thu, 13 Jul 2023 06:12:10 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48A7A3F73F;
        Thu, 13 Jul 2023 06:11:26 -0700 (PDT)
Date:   Thu, 13 Jul 2023 14:11:23 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] scsi: ufs: ufs-mediatek: Remove surplus dev_err()
Message-ID: <20230713131123.uo5ofltbhvktkevd@bogus>
References: <20230712064832.44188-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712064832.44188-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2023 at 02:48:32PM +0800, Yang Li wrote:
> There is no need to call the dev_err() function directly to print a
> custom message when handling an error from either the platform_get_irq()
> or platform_get_irq_byname() functions as both are going to display an
> appropriate error message in case of a failure.
> 
> ./drivers/ufs/host/ufs-mediatek.c:864:3-10: line 864 is redundant because platform_get_irq() already prints an error
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5846

Acked-by: Sudeep Holla <sudeep.holla@arm.com>

-- 
Regards,
Sudeep
