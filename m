From: David Miller <davem@davemloft.net>
Subject: Re: slave_configure for qlogicpti
Date: Sun, 30 Sep 2007 18:24:12 -0700 (PDT)
Message-ID: <20070930.182412.08350831.davem@davemloft.net>
References: <20070919124637.GE7624@parisc-linux.org>
	<20070930.172952.85384131.davem@davemloft.net>
	<470044DD.40100@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <470044DD.40100@garzik.org>
Sender: sparclinux-owner@vger.kernel.org
To: jeff@garzik.org
Cc: matthew@wil.cx, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Sun, 30 Sep 2007 20:52:45 -0400

> David Miller wrote:
> > It compiles :-)  You deleted the only uses of scsi_rbuf_{get,put}()
> > so you can kill those off too.
> 
> 
> Seeing as how they are exact duplicates of libata's 
> ata_scsi_rbuf_{get,put}, I wonder how they got there in the first place 
> (rather than becoming common code), and I wonder how many more copies 
> are floating out there...

I bet: 1) they were common code in scsi_lib.c 2) qlogicpti and libata
became the only remaining users so 3) they got copied to those
two users verbatim anticipating that the qlogicpti usage would
eventually be deleted.

Interested parties can search the tree history to determine for
suer :-)

