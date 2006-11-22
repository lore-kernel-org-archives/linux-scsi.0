From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 4/5] e1000 : Make Intel e1000 driver
	legacy I/O port free
Date: Wed, 22 Nov 2006 08:11:28 -0800
Message-ID: <456476B0.70705@intel.com>
References: <4564050C.70607@jp.fujitsu.com>
	<1164185809.31358.714.camel@laptopd505.fenrus.org>
	<20061122135423.GV18567@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20061122135423.GV18567@parisc-linux.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@osdl.org>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Nov 22, 2006 at 09:56:49AM +0100, Arjan van de Ven wrote:
>> On Wed, 2006-11-22 at 17:06 +0900, Hidetoshi Seto wrote:
>>>  static struct pci_device_id e1000_pci_tbl[] = {
>>> +	INTEL_E1000_ETHERNET_DEVICE(0x1004, 0),
>>> +	INTEL_E1000_ETHERNET_DEVICE(0x1008, E1000_USE_IOPORT),
>> Hi,
>>
>> this has the unfortunate effect that it's now a lot harder to add PCI
>> ID's to this driver at runtime via sysfs ;(
> 
> It does?  Normally you get 0 passed in that field, so you'll just not
> get io ports enabled ...
> 
> Need to set use_driver_data to get non-0 passed in that field.

I think we want to condense the USE_IOPORT flag together with the other hardware feature 
flags, as suggested by Jeff Garzik. This would save some headroom and leave the pci 
device id table as it is.

Cheers,

Auke

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
