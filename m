From: Kearnan_Keith@emc.com
Subject: RE: resizing LUN (not file system) while the file system (ext3) i
	 sonline
Date: Fri, 26 May 2006 08:24:36 -0400
Message-ID: <4A8F680AC6EC43458BCAE06010D8E81B028424AF@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([168.159.213.200]:41823 "EHLO
	mexforward.lss.emc.com") by vger.kernel.org with ESMTP
	id S932405AbWEZMY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 08:24:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: paul@briny.ondioline.org
Cc: lance.lmwang@gmail.com, linux-scsi@vger.kernel.org, admitriev@mentora.com, sct@redhat.com


Perfect, thank you Paul!  

That command wasn't around in the version I initially tested, SLES9sp2:
lvm2-2.00.33-1.3.  
I see that it is in RHEL4u3: lvm2-2.02.01-1.3.RHEL4.  

Does anyone know which version of LVM it was introduced in?

Cheers,

-Keith

-----Original Message-----
From: Paul Collins [mailto:paul@briny.ondioline.org] 
Sent: Thursday, May 25, 2006 11:41 PM
To: Kearnan, Keith
Cc: lance.lmwang@gmail.com; linux-scsi@vger.kernel.org;
admitriev@mentora.com; sct@redhat.com
Subject: Re: resizing LUN (not file system) while the file system (ext3) i
sonline

Kearnan_Keith@emc.com writes:

> The scenario was that there was no free space on the PV which was made
> up of a singe partition /dev/sdc1.  The customer used back end tools to
> expand /dev/sdc1.  I couldn't figure out a way to let LVM know that
> /dev/sdc1 was now "bigger".  In the end we simply had the customer add a
> new PV (/dev/sdd1) in order to vgextend/lvextend the file system.

It looks like like LVM2's pvresize command should be able to do this.

-- 
Paul Collins
Melbourne, Australia

Dag vijandelijk luchtschip de huismeester is dood
