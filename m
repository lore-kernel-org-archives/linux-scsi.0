From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 13:52:42 -0700
Message-ID: <OF72A6C80A.A5EC4A9A-ON8825729C.007161FD-8825729C.0072AF6A@us.ibm.com>
References: <45F59DF7.2070603@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45F59DF7.2070603@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ric Wheeler <ric@emc.com>
List-Id: linux-scsi@vger.kernel.org

>> I don't get this.  If you mean partitions defined by the classic DOS 
>> partition table format, then AFAICS, such a partition can start in any 
>> sector.
>
>    Only at "logical cylinder boundary" (except for the first partition).

That's a requirement in ancient DOS systems that use CHS addressing 
(physical CHS, no less), isn't it  (so you can properly convert a 
within-partition address to a within-disk address)?

While I would guess most people still partition disks that way (Even 
linux-util fdisk seems to do it by default), they don't have to.

Doesn't matter for this discussion, though.  As Doug demonstrated, even 
when you do start at cylinder boundaries, half your partitions start on an 
even sector, because typical cylinders have an odd number of sectors.

