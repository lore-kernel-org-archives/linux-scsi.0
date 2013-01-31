From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/1] Fix oops while resetting an ipr adapter
Date: Wed, 30 Jan 2013 23:45:07 -0600
Message-ID: <20130131054507.796972036@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:64877 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750941Ab3AaFxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2013 00:53:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com

When hotplug removing an adapter, we've seen the issues with
scsi_unblock_requests running after the adapter's memory has been
freed. This patch fixes the oops while resetting an ipr adapter.

Thanks!
Wendy

-- 
