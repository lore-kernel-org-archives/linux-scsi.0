From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Fri, 12 Aug 2016 16:08:36 -0400
Message-ID: <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	<146706367078.29152.14405582249219794335.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38666 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbcHLUJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 16:09:15 -0400
In-Reply-To: <146706367078.29152.14405582249219794335.stgit@brunhilda> (Don
	Brace's message of "Mon, 27 Jun 2016 16:41:10 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don,

Don> Depends on smartpqi driver adoption

-    { 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /* Adaptec PMC Series 9 */

How are people that load aacraid in their initrd going to boot after
this?

-- 
Martin K. Petersen	Oracle Linux Engineering
