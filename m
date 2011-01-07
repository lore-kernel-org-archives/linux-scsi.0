From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [linux-pm] [RFC] Deferred disk spinup during system resume
Date: Thu, 06 Jan 2011 22:16:49 -0500
Message-ID: <4D2685A1.6020708@pobox.com>
References: <1294363046-28820-1-git-send-email-maksim.rayskiy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35909 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab1AGDRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 22:17:00 -0500
Received: by qyj19 with SMTP id 19so44549qyj.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jan 2011 19:16:59 -0800 (PST)
In-Reply-To: <1294363046-28820-1-git-send-email-maksim.rayskiy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: maksim.rayskiy@gmail.com
Cc: linux-scsi@vger.kernel.org, tj@kernel.org

On 01/06/2011 08:17 PM, maksim.rayskiy@gmail.com wrote:
> Jeff,
>
> Okay, I moved EH scheduling to ata_qc_issue(). But since now  START taskfile is
> created in ata_eh_maybe_verify() I do not see why the same code has to
> remain in ata_scsi_start_stop_xlat. Does it make sense?

The taskfile you are to pass to the hardware is created in 
atapi_start_stop_xlat(), so you should not create a new taskfile in
ata_eh_maybe_verify()

	Jeff



