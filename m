From: Luben Tuikov <luben@splentec.com>
Subject: Re: Re: inquiry in scsi_scan.c
Date: Mon, 06 Jan 2003 17:40:09 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3E1A05C9.9040608@splentec.com>
References: <A5974D8E5F98D511BB910002A50A66470580D4F6@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: 'Matthew Dharm' <mdharm-scsi@one-eyed-alien.net>, Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Cress, Andrew R wrote:
> I think SCSI-Core should care about offsets 36-48, since that is where the
> serial number usually is returned.  Special error handling for emulated
> devices would be better than limiting the inquiry up front I think.

We were discussing the case when CmdDt = 0 and EVPD = 0.
This is the ``Standard INQUIRY data format'' table SPC-3.

-- 
Luben




-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
