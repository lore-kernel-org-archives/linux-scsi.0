From: jshankar <jshankar@CS.ColoState.EDU>
Subject: RE: queue depth help!!
Date: Wed, 31 Dec 2003 09:23:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FF4A594@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chico.cs.colostate.edu ([129.82.45.30]:47867 "EHLO
	chico.cs.colostate.edu") by vger.kernel.org with ESMTP
	id S265193AbTLaQXa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 11:23:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hello James,

Case :queue depth=1

On issuing a scsi command write, does the  data needs to be written 
succesfully 
to disk before issuing a scsi response. Is there a chance that the previous 
command's data is still cached on scsi controller and the next command issued 
is executed.

Please let me know if there are any  good tools for scsi analyzer.

Thanks
Jay



>===== Original Message From James Bottomley <James.Bottomley@SteelEye.com> 
=====
>On Sat, 2003-12-27 at 15:38, jshankar wrote:
>> if the scsi target queue depth is 1, does it mean that i can handle only 
one
>> outstanding command  at a time.
>
>Yes
>
>> Does it mean if another command is issued( queue depth=1), it has to wait 
till
>> the previous command is done.
>
>Yes.
>
>The mid-layer will start the queued command as soon as the one occupying
>the device returns...this is often why untagged devices actually set
>their depth to 2 so they can have another command all prepared and ready
>to roll as soon as the in-progress one returns.
>
>James

