From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Advice on getting the scsi device name.
Date: Fri, 4 Jun 2004 13:20:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF2B3D29ED.4D5AB48D-ON85256EA9.005E68DF-88256EA9.005F4523@us.ibm.com>
References: <1086317300.1023.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:9453 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265893AbUFDRUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 13:20:52 -0400
In-Reply-To: <1086317300.1023.9.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Danny Leong <danny@trek2000.com.sg>
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

>I am writing a program that needs to safely and correctly identify and
>mount a dev/sda ... dev/sda1 or dev/sdb etc.As far my knowledge fits me,
>i have to manually check the entry on proc/scsi/scsi to determine.
>Please advice me on a better method that could be included in a C
>program.

That depends a lot on what you consider a correct identification.  I can't 
think of any identification that /proc/scsi/scsi would help with. 

At a minimum, you usually have to do an ioctl to the device to find out 
its host, bus, target, and lu numbers.  Typically, even that isn't enough 
of an identification and you have to read VPD from the lu or read a volume 
label from the disk to really know what entity is behind /dev/sda.

What sort of identification are you looking for?

