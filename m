From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Thu, 11 Apr 2002 10:01:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD3472D22.54A9A865-ON87256B98.0056A1A5@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: linux-scsi@vger.kernel.org

>                VLUN = virtual LUN 
>
>This would be the number assigned by the storage system. A storage
>system can be broken up into multiple virtual storage systems each unique 
to
>the owner. The real trick is when to virtual storage systems share the 
same
>LUN.

This VLUN sounds like what SCSI/FCP defines as a LUN.  What you're calling 
a LUN is apparently something that's not defined in SCSI.  I'm guessing a 
LUN here identifies a volume, and the same volume is connected to multiple 
SCSI logical units, one in each virtual storage subsystem.  I'm also 
assuming that a virtual storage subsystem is a target device/node in SCSI 
terms.

That raises the question:  What do you get if you INQUIRE as to the 
logical unit serial number of two SCSI logical units, in different virtual 
storage subsystems, associated with the same volume?  Is it the same 
serial number?
