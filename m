From: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Subject: Re: AIC7902 lockups
Date: Mon, 11 Aug 2003 20:41:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811204139.A26663@laokoon.bug.net>
References: <20030811143610.A19365@laokoon.bug.net> <2429712704.1060622870@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hirsch.in-berlin.de ([192.109.42.6]:14728 "EHLO
	hirsch.in-berlin.de") by vger.kernel.org with ESMTP id S273028AbTHKSpM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 14:45:12 -0400
Content-Disposition: inline
In-Reply-To: <2429712704.1060622870@aslan.btc.adaptec.com>; from gibbs@scsiguy.com on Mon, Aug 11, 2003 at 11:27:50AM -0600
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

Justin,

On Mon, Aug 11, 2003 at 11:27:50AM -0600, Justin T. Gibbs wrote:
> > 
> > sorry for asking again, but my problem with two disks connected
> > to an Adaptec AIC7902 still exists. Any help to solve the
> > annoying problem or hints are greatly appreciated.
> 
> The messages are not complete... the top is clipped.  Were you
> using a serial console to capture this log?
No, i did a "dmesg > file", but it seems the buffer is full after
booting so the first parts are lost. I've put syslog files on the web:
http://laokoon.in-berlin.de/~beutin/messages.gz
http://laokoon.in-berlin.de/~beutin/syslog.gz
http://laokoon.in-berlin.de/~beutin/debug.gz

And i tried to catch more dmesg output in a startup script. The result
is here: http://laokoon.in-berlin.de/~beutin/dmesg-boot.log.gz

The dmesg output from a shell right after complete boot is here:
http://laokoon.in-berlin.de/~beutin/dmesg-start.log.gz

And the dmesg output after trying to use one of the fujitsu drives
is here: http://laokoon.in-berlin.de/~beutin/dmesg-hd-access.log.gz

If You need more logs please tell me, i'll provide it.


> Can you compile your kernel with register pretty printing enabled
> in the driver?  It is a config time menu option.  This greatly
> simplifies understanding the logs.
The logs mentioned above are generated after reboot with a new kernel
compiled with CONFIG_AIC79XX_REG_PRETTY_PRINT=y

> Can you also provide the output of "lspci -vv -n" from the
> system as well as the output from "dmesg" right after boot.
For dmesg output please see above; the lspci output is here:
http://laokoon.in-berlin.de/~beutin/lspci.log.gz

Any help welcome, thanks for reading!
-tb
-- 
Thomas Beutin                             tb@laokoon.IN-Berlin.DE
Beam me up, Scotty. There is no intelligent live down in Redmond.
