From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/5] ipr: Don't set NO_ULEN_CHK bit when resource is a
 vset.
Date: Tue, 3 Nov 2015 20:52:53 -0600
Message-ID: <56397305.5050207@linux.vnet.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446575170-18656-2-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:58481 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbKDCw5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 21:52:57 -0500
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 3 Nov 2015 19:52:57 -0700
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 6BA4738C8039
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2015 21:52:54 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA42qsZQ63963256
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 02:52:54 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA42qr6V015787
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 21:52:53 -0500
In-Reply-To: <1446575170-18656-2-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: wenxiong@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

