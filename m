From: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Subject: Re: AIC7902 lockups
Date: Wed, 13 Aug 2003 21:39:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030813213915.A20993@laokoon.bug.net>
References: <20030811143610.A19365@laokoon.bug.net> <2429712704.1060622870@aslan.btc.adaptec.com> <20030811204139.A26663@laokoon.bug.net> <3244592704.1060799839@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hirsch.in-berlin.de ([192.109.42.6]:19145 "EHLO
	hirsch.in-berlin.de") by vger.kernel.org with ESMTP id S275352AbTHMTpK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 15:45:10 -0400
Content-Disposition: inline
In-Reply-To: <3244592704.1060799839@aslan.btc.adaptec.com>; from gibbs@scsiguy.com on Wed, Aug 13, 2003 at 12:37:19PM -0600
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

Hi Justin,

thanks for Your answer!

On Wed, Aug 13, 2003 at 12:37:19PM -0600, Justin T. Gibbs wrote:
> >> The messages are not complete... the top is clipped.  Were you
> >> using a serial console to capture this log?
> > No, i did a "dmesg > file", but it seems the buffer is full after
> > booting so the first parts are lost. I've put syslog files on the web:
> 
> ...
> 
> The logs are still not complete.  As best I can tell, the controller
> is seeing CRC errors when talking to the Fujitsu drives, but these
> drives are hanging up the bus instead of responding to our ATN condition.
> I believe that these drives have newer firmware available that might
> aid in CRC error recovery, but you should also double check your
> cable, termination, etc.
I've put another syslog file on the web. IMHO it shows all the errors
with the scsi system. It's on
http://laokoon.in-berlin.de/~beutin/syslog.gz
If i can increase the debug level i will do it if it helps!

I cannot imagine a cabling problem, because the drives are in a hot
swap backplane and i changed the places of the drives (but having
the IBM drive every time as the first drive).
Or is it possible to have a bad cable from the board to the backplane,
beeing ok for the U160 IBM drive but not for a U360 drive? I'm using
the SCSI cable coming with the board, but i will try another next
time i've access to the machine.
Do You think, it could help to set the controller maximum to U160 on
the expected SCSI-IDs for the fujitsu drives?

Do You have any idea where to find the firmware an an update tool
for fujitsu drives?

Any hints or help welcome!

Thanks for reading!
-tb
-- 
Thomas Beutin                             tb@laokoon.IN-Berlin.DE
Beam me up, Scotty. There is no intelligent live down in Redmond.
