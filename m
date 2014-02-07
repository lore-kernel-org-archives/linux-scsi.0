From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Dynamic scsi_debug module
Date: Fri, 07 Feb 2014 15:46:25 -0500
Message-ID: <yq1r47eslb2.fsf@sermon.lab.mkp.net>
References: <52F5339B.7070503@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaBGUqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 15:46:30 -0500
In-Reply-To: <52F5339B.7070503@ubuntu.com> (Phillip Susi's message of "Fri, 07
	Feb 2014 14:27:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Phillip" == Phillip Susi <psusi@ubuntu.com> writes:

Phillip> Is it possible to use the scsi_debug module to create more than
Phillip> one device?  It seems to me that it needs rewritten to have an
Phillip> interface to dynamically create devices and set their
Phillip> parameters with a tool like losetup, rather than using module
Phillip> parameters.

The question is how much sense it makes to invest in scsi_debug now that
we have the LIO target in the kernel?

-- 
Martin K. Petersen	Oracle Linux Engineering
