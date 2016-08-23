From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 5/6] target/tcm_fc: Update debugging statements to match
 libfc usage
Date: Tue, 23 Aug 2016 11:07:00 -0700
Message-ID: <62b84b56-63be-dfbb-5bda-97aad34d60d6@sandisk.com>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
 <1471856051-87398-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0052.outbound.protection.outlook.com ([104.47.40.52]:41952
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752298AbcHWSHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Aug 2016 14:07:41 -0400
In-Reply-To: <1471856051-87398-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.com>

On 08/22/2016 01:54 AM, Hannes Reinecke wrote:
> +	char *reason = "no session created";

Please use const char* instead of char* in the above declaration.

Thanks,

Bart.
