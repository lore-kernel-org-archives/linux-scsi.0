From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add VPD support to aacraid
Date: Thu, 25 Jan 2007 10:19:59 -0800
Message-ID: <20070125101959.7ea05ddf.randy.dunlap@oracle.com>
References: <45B87336.5070707@suse.de>
	<45B87CB7.80102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:30032 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965559AbXAYSY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 13:24:58 -0500
In-Reply-To: <45B87CB7.80102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 25 Jan 2007 10:47:35 +0100 Hannes Reinecke wrote:

+/* Function: setinqserial
+ *
+ * Arguments: [1] pointer to void [1] int

Hi--
What does that notation mean?  (I know, you copied it. :)

Parts of this source file use kernel-doc and parts don't.
Would be nice to see it converted to all kernel-doc...

---
~Randy
