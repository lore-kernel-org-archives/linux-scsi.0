From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH v3 04/10] libfcoe: rename libfcoe.c to
 fcoe_cltr.c for the	coming fcoe_transport.c
Date: Fri, 14 Jan 2011 17:27:36 -0800
Message-ID: <1295054856.1836.3.camel@fritz>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
	 <20110113022002.12798.45641.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24937 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1AOB1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 20:27:38 -0500
In-Reply-To: <20110113022002.12798.45641.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yi Zou <yi.zou@intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Wed, 2011-01-12 at 18:20 -0800, Yi Zou wrote:
> The existing libfcoe.c is mostly for FIP support, rename it to reflect that
> fact and so we can add fcoe_transport.c to the make file to include both
> into the libfcoe kernel module.
> 
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> ---
> 
>  drivers/scsi/fcoe/fcoe_ctlr.c | 2690 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 2690 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/fcoe/fcoe_ctlr.c

This isn't renaming the file, it's copying it. Should this patch move
the file and then update Kconfig so that libfcoe builds?

//Rob

