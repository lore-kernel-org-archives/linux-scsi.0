From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 2/5] PCI : Move pci_fixup_device and
	is_enabled
Date: Wed, 22 Nov 2006 11:09:01 -0700
Message-ID: <20061122180901.GD378@colo.lackof.org>
References: <456404EF.3090902@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <456404EF.3090902@jp.fujitsu.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andrew Morton <akpm@osdl.org>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 22, 2006 at 05:06:07PM +0900, Hidetoshi Seto wrote:
> --- linux-2.6.19-rc6.orig/drivers/pci/pci.c
> +++ linux-2.6.19-rc6/drivers/pci/pci.c
> @@ -558,12 +558,18 @@
>  {
>  	int err;
> 
> +	if (dev->is_enabled)
> +		return 0;

This is unfortunately going to collide with the previous
patch posted by inaky@linux.intel.com:

    Subject: [patch 0/2] pci: make pci_{enable,disable}_device() be nested

grant

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
