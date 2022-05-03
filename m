Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08E2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 15:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiECPxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 11:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiECPxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 11:53:35 -0400
Received: from gherkin.frus.com (cpe-67-11-228-40.satx.res.rr.com [67.11.228.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A905E33EBC;
        Tue,  3 May 2022 08:50:02 -0700 (PDT)
Received: by gherkin.frus.com (Postfix, from userid 500)
        id 0E5E867B8B; Tue,  3 May 2022 10:50:01 -0500 (CDT)
Date:   Tue, 3 May 2022 10:50:01 -0500
From:   Bob Tracy <rct@frus.com>
To:     John Garry <john.garry@huawei.com>
Cc:     debian-alpha@lists.debian.org, Michael Cree <mcree@orcon.net.nz>,
        linux-alpha@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 5.17.0 boot issue on Miata
Message-ID: <YnFPKc92th8Pf7aJ@gherkin.frus.com>
References: <Yj0u150JJpsb9nj4@gherkin.frus.com>
 <20220326222157.GA13650@tower>
 <YkuejknyPDJoQEDC@gherkin.frus.com>
 <20220405050125.GA25969@tower>
 <YkxKRElYUhMgOOCN@gherkin.frus.com>
 <10d61d8f-edfc-fc39-0936-233692464dbd@gmx.de>
 <Yk4XsdHvjrLqN1LR@gherkin.frus.com>
 <YlAyZdZ6afL58Ege@gherkin.frus.com>
 <Yl5AXvU+cBH5ex4K@gherkin.frus.com>
 <2fe555d8-9bb8-59ca-d0c7-d2ad6249f50a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fe555d8-9bb8-59ca-d0c7-d2ad6249f50a@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 25, 2022 at 10:26:46AM +0100, John Garry wrote:
> Please try v5.18-rc2 as it should have a fix in commit eaba83b5b850

Up and running on v5.18-rc5 as I type this.  Fix confirmed.  Thanks!

--Bob
