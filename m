From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: Possible bug in usb storage (2.6.11 kernel)
Date: Tue, 27 Sep 2005 23:46:16 +0900 (JST)
Message-ID: <20050927.234616.36922370.anemo@mba.ocn.ne.jp>
References: <20050927.223801.130240000.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.44L0.0509271020180.5703-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0509271020180.5703-100000@iolanthe.rowland.org>
Sender: linux-usb-users-admin@lists.sourceforge.net
Errors-To: linux-usb-users-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
To: stern@rowland.harvard.edu
Cc: jim.ramsay@gmail.com, mdharm-kernel@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> On Tue, 27 Sep 2005 10:21:17 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> said:

stern> Yes I did.  You can see it at
stern> https://lists.one-eyed-alien.net/pipermail/usb-storage/2005-September/001953.html

Thank you.  But 'kmalloc(US_SENSE_SIZE, GFP_KERNEL)' is not enough (at
least) for MIPS since some MIPS chips have 32 byte cacheline and
ARCH_KMALLOC_MINALIGN is 8 on linux-mips.

Using 'max(dma_get_cache_alignment(), US_SENSE_SIZE)' would be OK.

---
Atsushi Nemoto


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
