From: "Quat Le" <Quat.Le@dothill.com>
Subject: RE: ATA Pass-Through support
Date: Thu, 2 Mar 2006 09:51:12 -0800
Message-ID: <DF9C50EF9E8CDA45A06FE8735C68F85E5692E5@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 17.129.dothill.com ([155.254.129.17]:59231 "EHLO
	earthex1.dothill.com") by vger.kernel.org with ESMTP
	id S932423AbWCBRvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 12:51:14 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, dougg@torque.net
Cc: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Moore, Eric [mailto:Eric.Moore@lsil.com]
> Sent: Wednesday, March 01, 2006 10:15 PM
> To: Quat Le; dougg@torque.net
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: ATA Pass-Through support
> 
> 
> No, the mptsas driver is not using libata, however we are using
> scsi_transport_sas.
> This is firmware assist implementation, meaning SCSI-to-ATA
translation
> is done in firmware; via queue_command entry point, all commands
> to both SAS and SATA devices are sent via SCSI_IO passthru.   Is the
SG_IO
> ATA passthru encapsalating an ATA command inside a SCSI CDB?
> If so, I don't think the firmware folks have not implemented that yet.
> When that is completed, I expect no change in driver, as its simply
> passthru, and the firmware will handle the request. There is an
> alternative,
> you can send an IOCTL=MPT_COMMAND IOCTL using
> the mptctl driver with the function set to
> MPI_FUNCTION_SATA_PASSTHROUGH.
> 
> 
> Eric Moore
> LSI Logic

Doug,
SG_IO ioctl provides SCSI pass-through. It's the new SCSI extensions ATA
Pass-Through commands (A1H and 85H) that sort of encapsulate ATA command
in a SCSI CDB. My application is using this interface to perform SMART
related functions to SATA drives. Could you please provide me with more
information on your MPT_COMMAND_IOCTL and MPI_FUNCTION_SATA_PASSTHROUGH?

Does anyone know of any SAS HBA vendor whose driver either uses libata
or supports SATA Pass-Through SCSI commands in their own layer? 

Thanks,
Quat Le
