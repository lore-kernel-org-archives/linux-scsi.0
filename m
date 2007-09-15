From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 0/8] mpt fusion
Date: Fri, 14 Sep 2007 18:45:22 -0600
Message-ID: <20070915004521.GA16789@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48270 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbXIOAxl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 20:53:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

These set of patchs are for scsi-misc git, hence post 2.6.23 kernels.  These basically cleaning up a large part of the code.

Contents of this series of patchs:

1) mm merges
2) standardize printks and debug info
3) adding/removing white space
4) rename vdev to vdevice
5) removing references to hd->ioc
6) removing Dell copyright
7) Kconfig cleanup
8) bump version to 3.04.06
