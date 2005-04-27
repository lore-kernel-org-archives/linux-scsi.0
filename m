From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [RFC] SAS domain layout for Linux sysfs
Date: Wed, 27 Apr 2005 16:54:53 +0200
Message-ID: <OF4CE413A0.DAB8B74B-ONC1256FF0.00505593-C1256FF0.0052A229@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:21928 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S261673AbVD0OzA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 10:55:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: andrew.patterson@hp.com, Eric.Moore@lsil.com, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Luben Tuikov <luben_tuikov@adaptec.com>, Madhuresh_Nagshain@adaptec.com, mike.miller@hp.com

Douglas Gilbert wrote
> It has been stated that the SAS discovery algorithm (i.e. the
> recursive use of SMP) should be implemented once in the SAS
> transport layer so that all SAS LLDs can use it. Putting
> the SAS discovery algorithm in the user space may be
> even more politically correct.

Similarly, in the case of Fibre Channel, a common N_Port or
SCSI target device discovery, preferably in user space, seems
to be desirable. This would require some CT and / or ELS
passthrough interface, for example in order to issue queries
to fabric switches.

regards
Martin Peschke

