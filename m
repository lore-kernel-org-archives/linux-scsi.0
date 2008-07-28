From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Mon, 28 Jul 2008 10:41:00 -0700
Message-ID: <20080728174100.GD12762@plap4-2.qlogic.org>
References: <488E02DE.5080100@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21267 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbYG1RlC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 13:41:02 -0400
Content-Disposition: inline
In-Reply-To: <488E02DE.5080100@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Mon, 28 Jul 2008, Vladislav Bolkhovitin wrote:

> This patch fixes race on dpc_thread field of struct scsi_qla_host,
> which can lead to crash on the module unload.
> 
> This patch is against 2.6.26
> 
> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

Vladislav,

Could you provide some details on the failure you encountered which
prompted this patch (backtrace/reproduction method)?
