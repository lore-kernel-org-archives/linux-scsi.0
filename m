From: Jeff Garzik <jeff@garzik.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 15:28:18 -0400
Message-ID: <45F5A9D2.4080406@garzik.org>
References: <OFCF49F323.33FDF27D-ON8825729C.0064FD4B-8825729C.0065C420@us.ibm.com> <45F5A6F7.9080108@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45F5A6F7.9080108@torque.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: dougg@torque.net
Cc: Bryan Henderson <hbryan@us.ibm.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ric Wheeler <ric@emc.com>
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Bryan Henderson wrote:
>> What is an odd-aligned disk?
> 
> s/disk/partition/ ?


Example:  An odd-aligned disk in the 512-b logical / 1K-physical 
scenario is where odd LBAs indicate the start of a 1K physical sector. 
An even-aligned disk is where even LBAs indicate the start of a 1K 
physical sector.

In order to avoid too many RMW cycles, partition software SHOULD (using 
IETF language) be aware of the underlying physical sector size 
alignment, in order to align paritions for optimal performance.

	Jeff


