From: "Claudio Coppari" <c.coppari@sintekno.it>
Subject: R: How can I know the status of a MegaRAID Array?
Date: Mon, 6 Feb 2006 16:44:17 +0100
Message-ID: <9B432F84A0C6FD488F8736A5DFC10DB44DCE38@mail.sintek.ita>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host242-129.pool82104.interbusiness.it ([82.104.129.242]:55223
	"EHLO mail.sintek.ita") by vger.kernel.org with ESMTP
	id S932192AbWBFPnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 10:43:01 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>



> > My question is: how can I know if one disk fails?
> > Is there something link /proc/mdstat ?
> > Alternatively: if one disk fail any message will be written 
> > to the log files? 

> By nature of RAID, you won't see any information for physical 
> disk drives associated to the RAID1.
> However, you will find the information for RAID1 from /proc.

Ok, but how can I know when a disk goes offline?
I wasn't able to find any information about the status of RAID1 in /proc

For example, with an LSI MegaIDE I get the following with
cat /proc/megaide/0/status

------------------------------------------------------------------------
Logical Drive Information
	Status : ONLINE  		Logical Drive No: 0

Physical Drive Information
			------  PRIMARY  ------		-----  SECONDARY  -----
			MASTER		SLAVE		MASTER		SLAVE
STATUS : 		ONLINE    	OFFLINE   	ONLINE    	OFFLINE   
No Of Errors : 		        0	       0	       0	       0
No Of Pending Commands :        0	       0	       0	       0
------------------------------------------------------------------------

Or, with an Adaptec SCSI controller, I get the following with the Adaptec utilities:


--------------------------------------------------------------------------
Adaptec SCSI RAID Controller Command Line Interface
Copyright 1998-2002 Adaptec, Inc. All rights reserved
--------------------------------------------------------------------------


Executing: open "aac0" 


Executing: container list 
Num          Total  Oth Stripe          Scsi   Partition    
Label Type   Size   Ctr Size   Usage   C:ID:L Offset:Size  
----- ------ ------ --- ------ ------- ------ -------------
 0    RAID-5  136GB       64KB Open    0:00:0 64.0KB:68.3GB 
 /dev/sda             ARRAY            0:02:0 64.0KB:68.3GB 
                                       0:04:0 64.0KB:68.3GB 



Executing: disk list 

C:ID:L  Device Type     Blocks    Bytes/Block Usage            Shared Rate
------  --------------  --------- ----------- ---------------- ------ ----
0:00:0   Disk            143374000 512         Initialized      NO     320 
0:02:0   Disk            143374000 512         Initialized      NO     320 
0:04:0   Disk            143374000 512         Initialized      NO     320 
