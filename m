From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Low I/O performance of PERC 4/DC on PE2650
Date: Thu, 2 Jun 2005 22:02:08 -0400
Message-ID: <200506030202.j5322D225595@www.watkins-home.com>
References: <1921045012.1117720904051.JavaMail.osg@osgjas02.cns.ufl.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:20150 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S261282AbVFCCCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2005 22:02:15 -0400
In-Reply-To: <1921045012.1117720904051.JavaMail.osg@osgjas02.cns.ufl.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Kadirvel, Selvi'" <selvik@ufl.edu>, linux-scsi@vger.kernel.org

What is the performance of a single disk?
Since you used 4 disks, at best, expect 4x the performance of a single disk.

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Kadirvel, Selvi
> Sent: Thursday, June 02, 2005 10:02 AM
> To: linux-scsi@vger.kernel.org
> Subject: Low I/O performance of PERC 4/DC on PE2650
> 
>  We use a PERC 4/DC card on a PowerEdge 2650 server. Connected to
> each SCSI bus is a set of 14 physical disks. Using the Dell
> Manager utility we create RAID 0 (logical) disk with 4-way stripes
> i.e 4 physical disks(across the two channels) and 128K block size.
> Using I/O benchmark applications like IOzone, the maximum
> throughput obtained is only about 100 MBps. We get lower values
> for other stripe sizes and block sizes. Shouldn't this be higher,
> considering that the SCSI bus provides 320 MBps throughput ? Does
> anyone know how to get better performance?
> 
>  Thanks.
>  -Selvi
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

