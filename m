From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [dm-devel] Re: fibre channel/multipath questions
Date: Tue, 30 Aug 2005 13:37:23 +0200
Message-ID: <431444F3.90305@s5r6.in-berlin.de>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>	 <20050829172316.GC7875@infradead.org> <1125378108.6375.15.camel@zezette>	 <200508301119.24072.Rik.Bobbaers@cc.kuleuven.be> <1125393973.3224.16.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:25829 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751369AbVH3Lhh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 07:37:37 -0400
In-Reply-To: <1125393973.3224.16.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>, christophe varoqui <christophe.varoqui@free.fr>

Arjan van de Ven wrote:
[|Rik Bobbaers wrote:]
>>the last rule poses the problem. depending on how many multipath devices i 
>>have, i constantly have to change lilo.conf for every machine.
>>
>>in bsd, there is a way to set your drives to a fixed name, is there something 
>>alike in linux? or a sollution to this problem? (i'm definately willing to 
>>help find one, if there isn't... and i guess i'm not the only one with this 
>>problem?)
> 
> there is mount-by-label (filesystem label that is) that at least Fedora
> and RHEL distros use, and I assume many other distros support too even
> if they don't use it by default.

Although I don't really know what mount-by-label on Fedora and RHEL 
means precisely, I suspect it may not help with the _bootloader_ and/or 
with RAID device files.

Rik, do you want to have the kernel image on a SAN disk? If _not_, there 
is a solution which has long been in use with USB and FireWire disks. 
Just install an initrd along with the kernel image. In the initrd, you 
can create or rename or link to device files as you whish. Typically, 
udev is used to fetch unique persistent properties of devices and 
associate device names, symlinks, or mount points accordingly.
-- 
Stefan Richter
-=====-=-=-= =--- ====-
http://arcgraph.de/sr/
