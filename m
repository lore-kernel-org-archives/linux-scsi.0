From: "Jeffrey W. Baker" <jwb@gghcwest.com>
Subject: build error with aic79xx on 2.4
Date: 05 Jun 2003 10:52:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054835575.22202.2.camel@heat>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.198.37.67] ([65.198.37.67]:992 "EHLO gghcwest.com")
	by vger.kernel.org with ESMTP id S264763AbTFERjZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2003 13:39:25 -0400
List-Id: linux-scsi@vger.kernel.org
To: gibbs@btc.adaptec.com, linux-scsi@vger.kernel.org

The latest aic79xx doesn't build in 2.4.21-rc3 because of Werror and
this warning:

aic79xx_osm_pci.c:278: warning: `ahd_linux_pci_reserve_mem_region'
defined but not used

That seemed harmless, so I removed Werror.  I'd try -rc7 but the
x86-64.org patches don't work against that kernel.

-jwb


