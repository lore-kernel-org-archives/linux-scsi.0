From: Mirko Benz <mirko.benz@web.de>
Subject: Re: SATA on mptsas performance
Date: Wed, 01 Mar 2006 09:16:14 +0100
Message-ID: <4405584E.6070806@web.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F28A5FF@NAMAIL2.ad.lsil.com> <43F2DDA7.7050700@web.de> <44051548.9090408@torque.net> <44053A8E.6000206@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 162.237.ddkom.net ([212.80.237.162]:30381 "EHLO
	cheetah.dd.xiranet.com") by vger.kernel.org with ESMTP
	id S1751115AbWCAIQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 03:16:57 -0500
In-Reply-To: <44053A8E.6000206@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Hello,

As promised we have tested 3 Gb (aka SATA II) disks.
Configuration: LSI SAS3442X controller, Promise SAS JBOD, 12 disks 
Seagate SATA 80 GB

Tested with parallel dd invocations with bs=32k.
The results look better:

# disks    Read    AVG    Write    AVG
1    69    69,0    68    68,0
6    420    70,0    324    54,0
7    459    65,6    367    52,4
8    426    53,3    394    49,3
9    399    44,3    389    43,2
10    410    41,0    431    43,1
11    438    39,8    428    38,9
12    468    39,0    481    40,1

Available bandwidth is 4 * 3 Gb = 1.5 GB (4 lanes / external wide SAS 
port).
So there is still some room for improvement. Has anyone else a similar 
setup and can provide results?
Maybe with the Adaptec SAS controller?

Thanks,
Mirko

Jeff Garzik schrieb:
> Douglas Gilbert wrote:
>> If the SATA disk does 3 Gb/sec then yes but SATA-1 disks
>> run at 1.5 Gb/sec (and don't have NCQ). When a SAS HBA
>
> To further confuse things, "SATA-1", "SATA-2", etc. don't mean much at 
> all.  I recommend never using these terms.
>
> There are many disks that can do NCQ but not 3 Gb/sec, for example.
>
> Its best just to mention the existence of features, because there is 
> no __technical__ definition of "SATA 2" that one can test in software. 
> SATA 2 is just a set of features defined by marketing.
>
>     Jeff
>
>

