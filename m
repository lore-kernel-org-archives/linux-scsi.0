Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B295C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 18:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12AF123C91
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 18:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732967AbgLIScC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 13:32:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728625AbgLIScB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Dec 2020 13:32:01 -0500
Date:   Wed, 9 Dec 2020 19:32:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607538681;
        bh=rBn44ACmBDduWYF/e+HnyAYG9t3o47m2NfhGycy0bNA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=YGiLEG8Wh88+FcmchlIdYL3sfTjgGnPIlb1kEBLomE9x2M09qDM1IUvK1VrS9k0/p
         4ncjHtSr+fYGuM3D1vvaFQ+IPAyuj/F/ZlzQbWhN/Pholu+wGWWQSe0Hfr6hqVgYIf
         CTdAmez0xrfjXsbQ10izRSsKDRSL+ttY55oG6UdY=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, lenb@kernel.org,
        rjw@rjwysocki.net, tglx@linutronix.de, maz@kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, linux-acpi@vger.kernel.org, dwagner@suse.de
Subject: Re: [PATCH v5 4/5] Driver core: platform: Add
 devm_platform_get_irqs_affinity()
Message-ID: <X9EYRNDXS1Xcy4iU@kroah.com>
References: <1606905417-183214-1-git-send-email-john.garry@huawei.com>
 <1606905417-183214-5-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606905417-183214-5-git-send-email-john.garry@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 02, 2020 at 06:36:56PM +0800, John Garry wrote:
> Drivers for multi-queue platform devices may also want managed interrupts
> for handling HW queue completion interrupts, so add support.

Why would a platform device want all of this?  Shouldn't such a device
be on a "real" bus instead?

What in-kernel driver needs this complexity?  I can't take new apis
without a real user in the tree, sorry.

thanks,

greg k-h
