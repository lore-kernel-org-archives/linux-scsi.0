Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A5DC77B6C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 22:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDLW0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 18:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLW0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 18:26:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A584228
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 15:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9254D63246
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 22:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1931DC433EF;
        Wed, 12 Apr 2023 22:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681338404;
        bh=ATdZy+QbUFQuAtMi4zhto4ZLmODTrfWiiqVjr9QkUCo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XcWt4iFOleI7K2WpXvVjABMNoKpNiAtK+w5TEyV6mgYPciE7NqVm4BY6oGfRf+Vap
         iLcNccpTqedPFt7G3BzD43SkTn8eXNO08gtrsT5C6qsLlz5id3Z/Es4p5yQCXlpubH
         gOxzH7Bjjp6y4sZUIcNCL0JkrLJuDRwYGY1BiNUZfhqDf95MPumccw9Jz1+GD0oSvM
         LHInPgefBRDimW0CeYjVx7XpglpaYFjFQt1OPjCVzp5BEKzNuyB+KjFwR+0EQqoSu0
         WcLJz3YMRxmlYrkg/GVt5LcgZkXt6bUaaTrS8h8z+Wqke6YSff1LSMwxgvPnOeWrCu
         Yf+yHG/44mguQ==
Message-ID: <6bc3786a-49c0-3ed9-0958-8e3f48aaad9a@kernel.org>
Date:   Thu, 13 Apr 2023 07:26:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] ipr: Remove SATA support
To:     Brian King <brking@linux.vnet.ibm.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        john.g.garry@oracle.com, wenxiong@linux.ibm.com
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/23 02:40, Brian King wrote:
> Linux SATA support in ipr has always been limited to SATA DVDs. The last
> systems that had the option of including a SATA DVD was Power 8,
> which have been withdrawn for sometime now, so this support can
> be removed.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Awesome ! Thanks for doing this. This will allow some major cleanup in libata EH
code !

I have no way to test this, but looks good:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


