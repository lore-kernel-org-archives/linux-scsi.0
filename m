From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH 1/4] dpt_i2o: use standard __init / __exit code
Date: Fri, 2 May 2008 09:18:19 -0400
Message-ID: <07D750C6-FD0F-4631-BFC5-E0EE9219C1B5@adaptec.com>
References: <20080501230528.GA19820@xs4all.net>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:57318 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764861AbYEBNSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 May 2008 09:18:20 -0400
In-Reply-To: <20080501230528.GA19820@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

ACK

On May 1, 2008, at 7:05 PM, Miquel van Smoorenburg wrote:

> [PATCH 1/4] dpt_i2o: use standard __init / __exit code
>
> Update dpt_i2o.c to use the standard __init / __exit
> code instead of the legacy '#include "scsi_module.c"' code.
>
> This is needed in preparation of 64-bit support. scsi_module.c
> calls scsi_add_host() with the device pointer set to NULL, and that
> crashes code like arch/x64/kernel/pci-gart_64.c::need_iommu().
>
> The reboot_notifier code is deleted because it wasn't compiled
> in ever anyway, and it would be useless to duplicate it in
> the new code.
>
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
>
