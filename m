From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/14] scsi: scsi_decide_dispostion update
Date: Tue, 02 Sep 2008 12:03:03 -0500
Message-ID: <48BD71C7.60306@cs.wisc.edu>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44208 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYIBRYt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 13:24:49 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> This patch series is an update to a previous set of patches posted by Mike
> Christie in the thread referenced below.
> http://thread.gmane.org/gmane.linux.scsi/44058/focus=4405

Thanks for posting this.

MikeA's patches replace my last two patches:
0008-block-separate-failfast-into-multiple-bits.patch (this is actually 
the same patch but sent again to make it easier it compile and test and 
review).
0009-scsi-modify-scsi-to-handle-new-fail-fast-flags.patch (MikeA's 
patches kill this patch).

MikeA also resent my
0003-scsi-add-transport-host-byte-errors-v3.patch so this could all 
compile and build and be tested together.
