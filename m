From: Matthew Jacob <mjacob@feral.com>
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 09:02:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204100902161.62427-100000@beppo>
References: <93F527C91A6ED411AFE10050040665D0049BF8D1@corpusmx1.us.dg.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <93F527C91A6ED411AFE10050040665D0049BF8D1@corpusmx1.us.dg.com>
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: hbryan@us.ibm.com, linux-scsi@vger.kernel.org


That's why you always trail lun off of the wwnn/wwpn- see solaris' ssd device
names.


On Wed, 10 Apr 2002 berthiaume_wayne@emc.com wrote:

> 	This is true with the design of today's virtual LUNs on the storage
> arrays. However, I believe that if you are sharing a VLUN on the array the
> same WWNN/WWPN is assigned to it. Though it may be represented to you as
> VLUN 1 in your virtual storage system and VLUN 6 in mine I thought the same
> WWNN/WWPN was assigned to it.
> 
> -----Original Message-----
> From: Bryan Henderson [mailto:hbryan@us.ibm.com]
> Sent: Tuesday, April 09, 2002 9:40 PM
> To: Rick Stevens
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [RFC] Persistent naming of scsi devices
> 
> 
> >E.g. "/dev/dsk/c0t1d2s3" is controller 0 (first SCSI controller seen on
> >the bus), target ID 1, LUN 2, partition (slice) 3.  Simple, unambiguous
> >and repeatable.
> 
> For many purposes, you're right, and for that reason devfs already does 
> this.  However, in some cases these are not repeatable.  A volume that is 
> LUN 5 today could be LUN 7 tomorrow.  This is true in heavy-duty disk 
> storage subsystems that let you create and destroy logical units on the 
> fly, using the physical medium as a resource pool.  And what is LUN 5 for 
> me could be LUN 7 for you at the same time, if we're both wired into the 
> same storage subsystem.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

