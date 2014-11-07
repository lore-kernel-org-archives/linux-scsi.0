From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: UNMAP command parameter list
Date: Fri, 7 Nov 2014 23:57:08 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295937B4CE@G4W3202.americas.hpqcorp.net>
References: <loom.20141108T001847-741@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:5648 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaKGX7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 18:59:11 -0500
In-Reply-To: <loom.20141108T001847-741@post.gmane.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andras Kovacs <akovacs@fixstars.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Andras Kovacs
> Sent: Friday, 07 November, 2014 5:30 PM
> To: linux-scsi@vger.kernel.org
> Subject: UNMAP command parameter list
> 
> 
>   Hi all,
> 
>   I'm trying to see what parameters are passed to the UFS driver from the
> SCSI midlayer when an UNMAP command is issued. In the UFS driver I can see
> the 10 byte command itself in the unsigned char *cmnd field of the struct
> scsi_cmnd, and it tells me that the parameter list length is 24 bytes (an 8
> byte UNMAP Parameter List header followed by one 16 byte long UNMAP Block
> Descriptor), but I'm having trouble finding where this UNMAP Parameter List
> is. It doesn't seem to be in the cmnd[] byte array after the UNMAP
> command itself.
> 
>   Can anyone tell me where I can find the UNMAP Parameter List which
> belongs to a particular UNMAP command?
> 
>   Any and all info would be greatly appreciated.
> 
>   Andras

That is the data transferred for the command, not in the
command descriptor block itself.

Typical T10 terminology is:
* parameter list = data-out buffer (i.e., write data)
* parameter data = data-in buffer (i.e., read data)


---
Rob Elliott    HP Server Storage



