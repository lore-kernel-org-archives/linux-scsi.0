From: Ludovico Cavedon <ludovico.cavedon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: USB HD: No Sense / Info fld=0x0 and read corruption
Date: Fri, 26 Dec 2008 11:38:06 +0100
Message-ID: <4954B40E.80403@gmail.com>
References: <Pine.LNX.4.44L0.0812241756020.917-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0812241756020.917-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 24 Dec 2008, Ludovico Cavedon wrote:
>> My question is: how can this happen? and not just one sector, but at
>> least a dozen!
>> Bad HD? (it's new! 93 hrs of activity so far!)
> 
> Maybe you can exchange it...

Definitely!

>>> It would also help to know what happens under Windows.  Do the same 
>>> "empty sense" errors occur?  If they do, how does Windows handle them?
>> I can try to use usb snoopy to log usb traffic under windows.
>> Do you know how I can ask Windows "read sector X"?
> 
> I wish I knew!  Perhaps Microsoft's KnowledgeBase site can tell you 
> how.

I found a free tool to read a raw sector of a partition (NT Disk
Viewer). Unfortunately USB Snoopy kept stopping capturing packets after
a few seconds, so I was not able to see what was happening.
Anyway, I goi a read error ofter a while the program seemed frozen. So I
guess Windows is handling them retrying to read the sector and finally
giving up.

A question:
If I rewrite these sectors I can fix these errors (at least
temporarily). I also noticed that when the "check condition" bit is set
some data is also tranferred. Is there get these partial data (e.g. with
dd)?

Thanks,
Ludovico

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
