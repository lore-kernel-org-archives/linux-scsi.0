From: berthiaume_wayne@emc.com
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Fri, 12 Apr 2002 14:03:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BF8EE@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hbryan@us.ibm.com
Cc: linux-scsi@vger.kernel.org

	I guess I hail back from when a LUN, or as I ahd always perceived
it, was a whole device and not a portion of one or several (if they were
bound in a RAID group.) =%^)

-----Original Message-----
From: Bryan Henderson [mailto:hbryan@us.ibm.com]
Sent: Friday, April 12, 2002 1:19 PM
To: berthiaume_wayne@emc.com
Cc: linux-scsi@vger.kernel.org
Subject: RE: [RFC] Persistent naming of scsi devices



That clarifies things a bit.  Clariion uses an unfortunate terminology; we
have to keep that in mind in these naming discussions because, for example,
when we talk a about making a device file name out of host/bus/target/lun,
we're talking about a Clariion VLUN, not a Clariion LUN.  The Clariion LUN
is what I believe most others would call a "volume."  Or maybe a virtual
disk.

>The physical LUN itself is not a physical disk in the physical
>array but created at the time you bind disks or portions of disks into
LUN.

Don't you feel funny saying "physical LUN" (physical logical unit number)?
:-) Is it physical or logical?  And is it a number or a storage medium?


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
