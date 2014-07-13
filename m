From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 02/10][SCSI]mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z (2.00.18) specifications
Date: Sun, 13 Jul 2014 10:58:06 -0400
Message-ID: <yq1a98dz4ox.fsf@sermon.lab.mkp.net>
References: <20140625103114.GA12896@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47442 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaGMO6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:58:40 -0400
In-Reply-To: <20140625103114.GA12896@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:01:14 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> Below is the change set in MPI2 Rev Y specification and in
Sreekanth> 2.00.17 header files
Sreekanth> 1) Added SCSIStatusQualifier to SCSI IO Error Reply message.
Sreekanth> 2) Added ATA Security Freeze Lock to IO Unit Page 1 Flags
Sreekanth>    field.

Sreekanth> Below is the change set in MPI2 Rev Z specification and in
Sreekanth> 2.00.19 header files
Sreekanth> 1) Added reserved fields to IO Unit Page 7 for future use.
Sreekanth> 2) Added optional functionality to IOCInit Request so that
Sreekanth>    the host may specify a separate base address for each
Sreekanth>    Reply Descriptor Post Queue. IOC support for this is
Sreekanth>    indicated using a new IOCCapabilities bit in the IOCFacts
Sreekanth>    Reply.
Sreekanth> 3) Added Toolbox Console Text Display Tool
Sreekanth>    The host uses the Console Text Display Tool to send a
Sreekanth>    string to IOC's Console using different console types (eg:
Sreekanth>    UART serial terminal or Ethernet terminal).

Sreekanth> The copyright in the mpi files is updated for year 2014

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
