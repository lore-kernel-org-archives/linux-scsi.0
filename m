From: Jens Axboe <axboe@suse.de>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 24 Mar 2003 19:19:46 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030324181946.GW2371@suse.de>
References: <0FA2250F5A23D64FBD983956F9B2864301ED5269@royntex01.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <0FA2250F5A23D64FBD983956F9B2864301ED5269@royntex01.iomegacorp.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Pat LaVarre <LAVARRE@iomega.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 24 2003, Pat LaVarre wrote:
> > For sd, we gauge the size of the command from the
> > size of the medium:  <1Gb=> six byte, from 1Gb to
> > 2Tb 10 byte, over 2Tb 16 byte
>  
> By now this theory we have completely disavowed?

Yes it was wrong, see earlier posting.

(BTW, top posting sucks...)

-- 
Jens Axboe



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
