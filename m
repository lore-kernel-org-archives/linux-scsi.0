From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: sd_read_cache_type
Date: Fri, 10 Jan 2003 09:35:32 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D523@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: 'James Bottomley' <James.Bottomley@steeleye.com>, Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


RE: cache
Yes, at least a synchronize, but can we always know (in time) if the medium
has been removed?  We may not always get an eject request, right?
I think write-back cache is inherently unsafe in general, but I guess we
have to allow unsafe things like that for non-production use.

Andy

-----Original Message-----
From: James Bottomley 
Sent: Friday, January 10, 2003 10:14 AM
[...]

Well, the cache is pretty often part of the permanent assembly, not part of 
the removable medium, so I think it should still be called for removable 
media. That begs the question, of course, what should the cache type be---it

strikes me as rather unsafe to have a removable RW medium with a write back 
cache?  I suppose at the very least we should to a SYNCHRONIZE on ejection
if 
it's write back?

James
[...]


-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
