From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v1] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_SMART PIO mode command.
Date: Mon, 02 Feb 2015 13:47:28 +0300
Message-ID: <54CF55C0.5080404@cogentembedded.com>
References: <1422872328-16700-1-git-send-email-stripathi@apm.com> <1422872328-16700-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:44356 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbbBBKr3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 05:47:29 -0500
Received: by mail-la0-f44.google.com with SMTP id s18so39447621lam.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2015 02:47:27 -0800 (PST)
In-Reply-To: <1422872328-16700-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com

Hello.

On 2/2/2015 1:18 PM, Suman Tripathi wrote:

> This patch addresses the issue with ATA_CMD_SMART pio mode
> command for enumeration and device detection with ATA devices.
> The X-Gene AHCI controller has an errata in which it cannot clear
> the BSY bit after the PIO setup FIS. The dma state machine enters
> CMFatalErrorUpdate state and locks up. It is the same issue as
> in the patch(Commit ID : 2a0bdff6b958d1b2523d2754b6cd5e0ea4053016).

    Just "in the commit 2a0bdff6b958d1b2523d2754b6cd5e0ea4053016". And you 
also need to specify the commit's summary line in parens.

> Signed-off-by: Suman Tripathi <stripathi@apm.com>

WBR, Sergei

