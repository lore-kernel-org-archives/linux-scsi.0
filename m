From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/1] Resend of zfcp adapter statistics
Date: Mon, 07 Jan 2008 17:43:30 +0100
Message-ID: <20080107164330.733068000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:43447 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbYAGQtF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 11:49:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>

James,

this is the extension for zfcp that adds some statistics retrieved
from the FCP adapter. This version already includes the fixes and
applies on top of the other patches on scsi-misc.

Like Swen mentioned before, this adds new data attributes that only
refer to one Linux system. Similar looking attributes for the FC host
refer to the adapter. Since the FCP adapter can be shared across
multiple Linux systems, the two groups of attributes have a different
scope.

-- 
Christof Schmitt
