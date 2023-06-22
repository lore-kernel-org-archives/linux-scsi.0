Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6236FEB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 16:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjFVQIY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jun 2023 12:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjFVQIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2023 12:08:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3269E199E;
        Thu, 22 Jun 2023 09:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB0E86189F;
        Thu, 22 Jun 2023 16:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D2EC433C0;
        Thu, 22 Jun 2023 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687450102;
        bh=87TexzUzpi9z6IPDVVcUrjEQBOCi3gtzBY3HMg8UQfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a+R2YX5qnePWxp24g0SOvSmOIdn5x56Mjm6tlflvYhuK/YQ+q03VEB3itY2jR4ilY
         GPEVF8vWJ9j8j0+TAWXBCXBi0OGzE0kNGtig8zIOzYVneu07krevjN3hgqkk5KorKJ
         A9HW9/0vJ2qIukXKAzHPEr4vsqZREau7JuTHqXaE=
Date:   Thu, 22 Jun 2023 18:08:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sreekanth.reddy@broadcom.com, stable@vger.kernel.org
Subject: Re: [PATCH] mpt3sas: Perform additional retries if Doorbell read
 returns 0
Message-ID: <2023062207-plywood-vindicate-c271@gregkh>
References: <20230615083010.45837-1-ranjan.kumar@broadcom.com>
 <2023061538-dizzy-amiable-9ec7@gregkh>
 <CAFdVvOwjQZZnViCYbJqPC81ZJPsZdqjNuQE=dH4bHWD4Pyu7Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFdVvOwjQZZnViCYbJqPC81ZJPsZdqjNuQE=dH4bHWD4Pyu7Ew@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 22, 2023 at 09:26:50AM -0600, Sathya Prakash Veerichetty wrote:
> -- 
> This electronic communication and the information and any files transmitted 
> with it, or attached to it, are confidential and are intended solely for 
> the use of the individual or entity to whom it is addressed and may contain 
> information that is confidential, legally privileged, protected by privacy 
> laws, or otherwise restricted from disclosure to anyone else. If you are 
> not the intended recipient or the person responsible for delivering the 
> e-mail to the intended recipient, you are hereby notified that any use, 
> copying, distributing, dissemination, forwarding, printing, or copying of 
> this e-mail is strictly prohibited. If you received this e-mail in error, 
> please return the e-mail to the sender, delete it from your computer, and 
> destroy any printed copy of it.

Now deleted.
