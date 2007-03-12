From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 11:31:36 -0700
Message-ID: <OFCF49F323.33FDF27D-ON8825729C.0064FD4B-8825729C.0065C420@us.ibm.com>
References: <45F56589.1020209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45F56589.1020209@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ric Wheeler <ric@emc.com>
List-Id: linux-scsi@vger.kernel.org

>DOS partitions start partitions on odd-numbered sectors

I don't get this.  If you mean partitions defined by the classic DOS 
partition table format, then AFAICS, such a partition can start in any 
sector.

>so presuming you have odd-aligned disks, life is good.

What is an odd-aligned disk?

