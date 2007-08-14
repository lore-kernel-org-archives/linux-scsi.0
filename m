From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 8885] New: Unable to access
	memory card	reader anymore
Date: Mon, 13 Aug 2007 23:19:26 -0500
Message-ID: <1187065166.3331.27.camel@localhost.localdomain>
References: <bug-8885-10286@http.bugzilla.kernel.org/>
	<20070813201354.baffcaba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070813201354.baffcaba.akpm@linux-foundation.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, linux-scsi@vger.kernel.org, casteyde.christian@free.fr, linux-kernel-announce@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>, bugme-daemon@bugzilla.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

> I'm struggling a bit to work out if this is a scsi bug, a USB bug, an MMC bug
> or whatever.  But it's a bug.
> 
> Michal, can you please track this as a post-2.6.22 regression?
> 
> Others: can you please take a look at the dmesg output, see if we can work
> out which subsystem is (newly) failing?

There's not enough info in the dmesg.  We really need the dmesg when
it's failing, not when it's booting up, so after the 

blockdev --rereadpt /dev/sda

and the

fdisk /dev/sda

If no messages at all, that's also significant (and I'd guess problems
with media change propagation).

James



-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
