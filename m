Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F41C25B0F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 17:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiHLRfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 13:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiHLRfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 13:35:07 -0400
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CFFB2743
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 10:35:03 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id 86348E0CC8;
        Fri, 12 Aug 2022 17:35:02 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 7648B6053F;
        Fri, 12 Aug 2022 17:35:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id 3nmE7vGcDsza; Fri, 12 Aug 2022 17:35:02 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-202-215.dyn.295.ca [104.157.202.215])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id D829460493;
        Fri, 12 Aug 2022 17:35:01 +0000 (UTC)
Message-ID: <30454ea8-63fb-12d5-5d34-0e872457dad8@interlog.com>
Date:   Fri, 12 Aug 2022 13:34:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Reply-To: dgilbert@interlog.com
Subject: Re: [sg3_utils 0/3] Prepare for removing /proc/scsi from the Linux
 kernel
Content-Language: en-CA
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
References: <20220810182739.756352-1-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20220810182739.756352-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-08-10 14:27, Bart Van Assche wrote:
> Hi Doug,
> 
> The sg3_utils package is the only /proc/scsi user I know of. Although support
> for systems without /proc/scsi was added to rescan_scsi_bus.sh more than ten
> years ago, a few references to /proc/scsi remain. Convert these references into
> the recommended interfaces.
> 
> Please consider these patches for inclusion in the sg3_utils package.

The three patches in this series have been applied to my upstream subversion
repository as revision 968 with a few cosmetic changes. That should now be
mirrored at: https://github.com/doug-gilbert/sg3_utils

Thanks
Doug Gilbert

