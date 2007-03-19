From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fusion :  shost max_id not set in VMWare guest os
Date: Mon, 19 Mar 2007 17:06:58 +0000
Message-ID: <20070319170658.GA3611@infradead.org>
References: <20070319163043.GA28055@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46971 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010AbXCSRHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 13:07:01 -0400
Content-Disposition: inline
In-Reply-To: <20070319163043.GA28055@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Mon, Mar 19, 2007 at 10:30:43AM -0600, Eric Moore wrote:
> [PATCH 1/2] fusion :  shost max_id not set in VMWare guest os
> 
> In vmware guest os with emulated LSI 53c1030, the port facts config page is
> not having MaxDevices initialized to 16 devices. Instead its set to zero.
> Thereforewhen driver loads, no devices are scanned for from scsi_scan_host.
> Prior to the3.04.04 driver, shost max_id was set to hard coded value MPT_MAX_SCSI_DEVICES. After that release, support for greater than 255 targets was added, and the driver was taking the target count from the port facts instead.  With this patch we will restore the hard coded values for SPI, but at the same time use the settingsneeded for SAS and Fibre Channel.

NACK, just get Vmware folks to fix their broken emulation.

