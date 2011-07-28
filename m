From: David Miller <davem@davemloft.net>
Subject: [PATCH 0/2]: mpt2sas bug fixes
Date: Wed, 27 Jul 2011 23:20:40 -0700 (PDT)
Message-ID: <20110727.232040.1989797326967015608.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:50239 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1G1GUp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2011 02:20:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kashyap.Desai@lsi.com, eric.moore@lsi.com


While bringing up my Niagara-T3 machine I found a couple of small
issues in the mpt2sas driver.

BTW, please add a tag to the top-level MAINTAINERS file so that
people can see who maintains this driver more easily.  Currently
there is a path present for drivers/message/fusion but not for
drivers/scsi/mpt2sas, thanks.
