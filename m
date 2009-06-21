From: David Miller <davem@davemloft.net>
Subject: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared - system
 is dreadfully slow)
Date: Sun, 21 Jun 2009 16:13:43 -0700 (PDT)
Message-ID: <20090621.161343.181101055.davem@davemloft.net>
References: <20090621.141950.160759111.davem@davemloft.net>
	<200906220034.22430.bzolnier@gmail.com>
	<20090621.155756.100422570.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20090621.155756.100422570.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: bzolnier@gmail.com
Cc: elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 21 Jun 2009 15:57:56 -0700 (PDT)

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 22 Jun 2009 00:34:22 +0200
> 
>> Lets get over this quickly, since you seem to have such a great
>> insight into running IDE layer here is a little proposition..
>> 
>> ACK?  [ If not than can we please get back with the program? ]
> 
> Acked-by: David S. Miller <davem@davemloft.net>

I've created a new IDE development tree at:

	master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git

and the first patch is below.

I'll ask the patchwork folks to add an IDE group so we can manage
patches posted here.

I'm going to treat IDE as pure legacy, rather than as competition
with the PATA drivers which is what people whould be moving over to.

And more importantly I refuse to apply any driver patch that isn't
actually tested on said hardware.

ide: Take over as maintainer.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d47043..487aaea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2802,10 +2802,10 @@ S:	Supported
 F:	drivers/scsi/ips.*
 
 IDE SUBSYSTEM
-P:	Bartlomiej Zolnierkiewicz
-M:	bzolnier@gmail.com
+P:	David S. Miller
+M:	davem@davemloft.net
 L:	linux-ide@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
 S:	Maintained
 F:	Documentation/ide/
 F:	drivers/ide/
-- 
1.6.3.2

