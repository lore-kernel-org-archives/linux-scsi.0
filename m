From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: Help - how to identify the callers in a SCSI lower-leveldriver
Date: Wed, 7 Apr 2004 15:42:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFA0@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 65-68-235-6.ded.swbell.net ([65.68.235.6]:54962 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264128AbUDGUmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2004 16:42:46 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: linux-scsi@vger.kernel.org

Thanks for the response.

The shim (a pseudo SCSI lower-level driver) we are working on sits in between Linux SCSI mid-level driver and our existing kernel driver which interfaces with a FC driver which interacts with the FC HBA.

To track SCSI initiators' tasks, it would be great if our existing kernel driver knows which application makes the (SCSI passthrough ioctl) call to /dev/sda.

Thanks,


Lee

-----Original Message-----
From: Arjan van de Ven [mailto:arjanv@redhat.com]
Sent: Wednesday, April 07, 2004 3:02 PM
To: Lee Xing
Cc: linux-scsi@vger.kernel.org
Subject: Re: Help - how to identify the callers in a SCSI
lower-leveldriver


On Wed, 2004-04-07 at 21:52, Lee Xing wrote:
> Hi,
> 
> I'm writing a pseudo Linux lower-level SCSI driver, which interfaces with the standard mid-level driver and needs to identify different calling applications in Linux user space.  For example, there are 2 applications, app1 and app2, in user space, and they both use /dev/hda.  We don't need the SCSI lower-level driver to know the applications' names "app1" or "app2", but just need it to tell the (SCSI passthrough ioctl) calls are from the "this" application or from "that" application.


you'll find that most IO's will come from the VM subsystem and not
directly from applications. Why do you think you need this functionality
????
