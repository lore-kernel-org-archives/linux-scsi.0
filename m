From: "Quat Le" <Quat.Le@dothill.com>
Subject: RE: ATA Pass-Through support
Date: Thu, 2 Mar 2006 10:00:53 -0800
Message-ID: <DF9C50EF9E8CDA45A06FE8735C68F85E5692EE@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 17.129.dothill.com ([155.254.129.17]:14434 "EHLO
	earthex1.dothill.com") by vger.kernel.org with ESMTP
	id S1751631AbWCBSAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 13:00:55 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quat Le <Quat.Le@dothill.com>, "Moore, Eric" <Eric.Moore@lsil.com>, dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> Doug,
> SG_IO ioctl provides SCSI pass-through. It's the new SCSI extensions
ATA
> Pass-Through commands (A1H and 85H) that sort of encapsulate ATA
command
> in a SCSI CDB. My application is using this interface to perform SMART
> related functions to SATA drives. Could you please provide me with
more
> information on your MPT_COMMAND_IOCTL and
MPI_FUNCTION_SATA_PASSTHROUGH?
> 
> 
> Thanks,
> Quat Le

Sorry, I was addressing the above to Eric (not Doug).
