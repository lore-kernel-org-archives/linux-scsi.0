From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/5] Update Documentation/pci.txt
Date: Fri, 22 Dec 2006 22:52:09 +0100
Message-ID: <458C5389.70704@s5r6.in-berlin.de>
References: <456404E2.1060102@jp.fujitsu.com>	<20061122182804.GE378@colo.lackof.org>	<45663EE8.1080708@jp.fujitsu.com>	<20061124051217.GB8202@colo.lackof.org>	<20061206072651.GG17199@kroah.com>	<20061210072508.GA12272@colo.lackof.org>	<20061215170207.GB15058@kroah.com>	<20061218071133.GA1738@colo.lackof.org>
	<20061222114658.01da661b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20061222114658.01da661b.randy.dunlap@oracle.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andrew Morton <akpm@osdl.org>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

> On Mon, 18 Dec 2006 00:11:33 -0700 Grant Grundler wrote:
...
>> +4.1 Stop IRQs on the device
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +How to do this is chip/device specific. If it's not done, it opens
>> +the possibility of a "screaming interrupt" if (and only if)
>> +the IRQ is shared with another device.
>> +
>> +When the shared IRQ handler is "unhoooked", the remaining devices
                                       ^^^
-> unhooked

...
>> +11. MMIO Space and "Write Posting"
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +Converting a driver from using I/O Port space to using MMIO space
>> +often requires some additional changes. Specifically, "write posting"
>> +needs to be handled. Many drivers (e.g. tg3, acenic, sym53c8xx_2)
>> +already do. I/O Port space guarantees write transactions reach the PCI
> 
>    already do this.
> 
>> +device before the CPU can continue. Writes to MMIO space allow to CPU
                                                                   ^^
>> +continue before the transaction reaches the PCI device. HW weenies
   ^
-> allow the CPU to continue

-- 
Stefan Richter
-=====-=-==- ==-- =-==-
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
