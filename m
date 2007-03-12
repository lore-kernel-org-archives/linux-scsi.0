From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 21:37:43 +0300
Message-ID: <45F59DF7.2070603@ru.mvista.com>
References: <OFCF49F323.33FDF27D-ON8825729C.0064FD4B-8825729C.0065C420@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <OFCF49F323.33FDF27D-ON8825729C.0064FD4B-8825729C.0065C420@us.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ric Wheeler <ric@emc.com>
List-Id: linux-scsi@vger.kernel.org

Hello.

Bryan Henderson wrote:

>>DOS partitions start partitions on odd-numbered sectors

> I don't get this.  If you mean partitions defined by the classic DOS 
> partition table format, then AFAICS, such a partition can start in any 
> sector.

    Only at "logical cylinder boudary" (except for the first partition).

