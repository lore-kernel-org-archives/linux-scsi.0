From: jshankar <jshankar@CS.ColoState.EDU>
Subject: RE: ide commands to scsi commands
Date: Tue, 24 Feb 2004 10:30:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403CFDC0@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chico.cs.colostate.edu ([129.82.45.30]:24749 "EHLO
	chico.cs.colostate.edu") by vger.kernel.org with ESMTP
	id S262330AbUBXRa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 12:30:59 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hello Jeff,

A while ago, i was working on iSCSI. My client was using ide interface and 
server was on scsi interface. I was wondering before the commands are sent to 
the server using the iSCSI protocol, doesn't it need to be able to sent in the 
scsi format.

Is there a ide-scsi bridge ?. How could one handle such scenario.

Thanks
Jay


>===== Original Message From Jeff Garzik <jgarzik@pobox.com> =====
>jshankar wrote:
>> Hello ,
>>
>> Is there a driver to issue scsi commands on receiving ide commands?.
>
>
>Why is there a need to do such a thing?
>
>	Jeff

