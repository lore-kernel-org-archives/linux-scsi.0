From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 5/5] lpfc : Make Emulex lpfc driver legacy
	I/O port free
Date: Wed, 3 Jan 2007 14:23:49 -0800
Message-ID: <20070103142349.6f8b0310.akpm@osdl.org>
References: <4564051C.3080908@jp.fujitsu.com> <4564706E.9060900@emulex.com>
	<1167862008.2789.81.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1167862008.2789.81.camel@mulgrave.il.steeleye.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Grundler <grundler@parisc-linux.org>, James.Smart@Emulex.Com, Grant@sc8-sf-spam2.sourceforge.net, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

On Wed, 03 Jan 2007 16:06:48 -0600
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2006-11-22 at 10:44 -0500, James Smart wrote:
> > ACK  :)
> > 
> > (I thought this had already gone in a while ago)
> 
> Actually, there seems to be missing infrastructure for this:
> 
>   CC [M]  drivers/scsi/lpfc/lpfc_init.o
> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_pci_probe_one':
> drivers/scsi/lpfc/lpfc_init.c:1418: warning: implicit declaration of function 'pci_select_bars'
> drivers/scsi/lpfc/lpfc_init.c:1422: warning: implicit declaration of function 'pci_request_selected_regions'
> drivers/scsi/lpfc/lpfc_init.c:1734: warning: implicit declaration of function 'pci_release_selected_regions'

That's here, in Greg's PCI tree:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-pci/pci-add-selected_regions-funcs.patch

> Is there any ETA on the rest of the infrastructure?
> 

It doesn't look like a bugfix :(

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
