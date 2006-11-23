From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/5] PCI : Add selected_regions funcs
Date: Thu, 23 Nov 2006 21:42:48 +0000
Message-ID: <20061123214248.6251a4c0@localhost.localdomain>
References: <456404FE.1040708@jp.fujitsu.com>
	<200611232033.35280.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200611232033.35280.ioe-lkml@rameria.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Andrew Morton <akpm@osdl.org>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

On Thu, 23 Nov 2006 20:33:32 +0100
Ingo Oeser <ioe-lkml@rameria.de> wrote:

> Hi Hidetoshi Seto,
> 
> bitfields (and bitmask) should be unsigned and use machine word size,
> which is usually "long". So please pass them in "unsigned long" instead of "int".

There are a fixed number of BARs , besides which the interface already
uses int for the mask in pci_enable_device_bars() so the use of int is
fine and continues the existing API.


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
