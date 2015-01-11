From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 4/4] scsi: esp_scsi: adjust module reference for
 scsi host
Date: Sun, 11 Jan 2015 12:55:53 -0500 (EST)
Message-ID: <20150111.125553.2199450584759764343.davem@davemloft.net>
References: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
	<1420984206-22341-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbAKRz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jan 2015 12:55:58 -0500
In-Reply-To: <1420984206-22341-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akinobu.mita@gmail.com
Cc: linux-scsi@vger.kernel.org, hare@suse.de, hch@lst.de, JBottomley@parallels.com

From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sun, 11 Jan 2015 22:50:06 +0900

> While accessing a scsi device on host adapter supported by sub driver for
> the ESP chip (mac_esp, am53c974, sun_esp, jazz_esp, sun3x_esp), the module
> reference count is not incremented.  Because these drivers allocate scsi
> hosts with scsi_esp_template defined in ESP SCSI driver core module.  So
> these drivers always can be unloaded.
> 
> This fixes it by passing correct module reference to newly introduced
> scsi_esp_host_alloc() so that .module field in struct Scsi_Host can be
> adjusted.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Looks fine to me, thanks for fixing this:

Acked-by: David S. Miller <davem@davemloft.net>
