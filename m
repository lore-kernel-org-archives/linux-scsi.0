Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0B2C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 09:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACFE7235E4
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 09:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbhAUJJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 04:09:02 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:35153 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726123AbhAUJIH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 04:08:07 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 25B272064790F;
        Thu, 21 Jan 2021 10:07:17 +0100 (CET)
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        John Garry <john.garry@huawei.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20210120184548.20219-1-mwilck@suse.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <936ea886-e7ae-c3c5-1bab-911754050fff@molgen.mpg.de>
Date:   Thu, 21 Jan 2021 10:07:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210120184548.20219-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20.01.21 19:45, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Donald: please give this patch a try.
> 
> Commit 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
> [...]


Unfortunately, this patch (on top of 6eb045e092ef) did not fix the problem. Same error (""controller is offline: status code 0x6100c"") after about 20 minutes of the test load.

Best
   Donald

