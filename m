From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] ahci_xgene: Fix the DMA state machine lockup for
 the ATA_CMD_PACKET PIO mode command.
Date: Mon, 5 Jan 2015 09:03:48 -0500
Message-ID: <20150105140348.GF15833@htj.dyndns.org>
References: <1419823367-11279-1-git-send-email-stripathi@apm.com>
 <1419823367-11279-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:58987 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbbAEODv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2015 09:03:51 -0500
Content-Disposition: inline
In-Reply-To: <1419823367-11279-3-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com

On Mon, Dec 29, 2014 at 08:52:47AM +0530, Suman Tripathi wrote:
> This patch addresses the issue with ATA_CMD_PACKET pio mode
> command for enumeration and device detection with ATAPI devices.
> The X-Gene AHCI controller has an errata in which it cannot clear
> the BSY bit after the PIO setup FIS. The dma state machine enters
> CMFatalErrorUpdate state and locks up.
> 
> Signed-off-by: Suman Tripathi <stripathi@apm.com>

Ah, you already posted the updated versions.  Applied these instead.

Thanks.

-- 
tejun
