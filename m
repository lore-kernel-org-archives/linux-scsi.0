From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 0/9] mpt fusion
Date: Mon, 17 Sep 2007 19:55:20 -0600
Message-ID: <20070918015520.GA22709@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61762 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXIRCEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 22:04:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

These set of patchs are for scsi-misc git, hence post 2.6.23 kernels.

1) adding usage of shost_priv and removing all the typecasting
2) Fixing sparse warnings
3) locking down ScsiLookup
4-9) error recovery improvements, and synchronizing internal commands (6 seperate patchs)
