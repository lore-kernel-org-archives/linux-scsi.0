From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 18/27] hpsa: refactor hpsa_figure_bus_target_lun
Date: Thu, 5 Nov 2015 10:18:13 -0600
Message-ID: <3ABFC66C-FEF5-4EC8-88F7-5B149E68A15F@linux.vnet.ibm.com>
References: <20151104214910.15472.23179.stgit@brunhilda> <20151104215145.15472.70649.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:52675 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162166AbbKEQS1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 11:18:27 -0500
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 5 Nov 2015 09:18:26 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 7497B3E40044
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2015 09:18:17 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA5GH8PZ8323406
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2015 09:17:08 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA5GIGWr022950
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2015 09:18:17 -0700
In-Reply-To: <20151104215145.15472.70649.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

