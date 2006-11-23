From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/5] PCI : Add selected_regions funcs
Date: Thu, 23 Nov 2006 12:39:05 -0700
Message-ID: <20061123193905.GD6083@parisc-linux.org>
References: <456404FE.1040708@jp.fujitsu.com>
	<200611232033.35280.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
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

On Thu, Nov 23, 2006 at 08:33:32PM +0100, Ingo Oeser wrote:
> bitfields (and bitmask) should be unsigned and use machine word size,
> which is usually "long". So please pass them in "unsigned long" instead of "int".

Why?  We know how many BARs PCI devices have (6.  Plus ROM.  Plus 4
bridge resources, making 11).  We could even use a u16.  An int is fine,
there's no need to re-spin this patch.

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
