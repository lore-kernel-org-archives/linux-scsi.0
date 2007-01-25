From: Edward Goggin <egoggin@vmware.com>
Subject: why no cmd_flags parameter for scsi_execute_async?
Date: Thu, 25 Jan 2007 17:19:04 -0500
Message-ID: <1169763544.6129.47.camel@egoggin-devd.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:59512 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030620AbXAYWRX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 17:17:23 -0500
Received: from mailhost2.vmware.com (mailhost2.vmware.com [10.16.64.160])
	by mailout1.vmware.com (Postfix) with ESMTP id 500525FE9
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2007 14:17:37 -0800 (PST)
Received: from PA-EXCH03.vmware.com (pa-exch-node04.vmware.com [10.16.64.143])
	by mailhost2.vmware.com (Postfix) with ESMTP id D7F52909BC
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2007 15:14:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Looks like a simple oversight, but does anyone know why there a
cmd_flags parameter for scsi_execute but not for scsi_execute_async?

Seems like this is lost functionality when scsi_execute_async replaced
scsi_do_req.  Previously, the caller of scsi_do_req could set the flags
field of the sr_request structure of the scsi_request parameter to the
function.

Is scsi_execute_async being replaced as part of the bidi patch set?

I'd like to submit a patch to fix this but I want to make sure its
worthwhile.
