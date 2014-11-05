From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: Large disk drives
Date: Wed, 5 Nov 2014 14:15:05 -0500
Message-ID: <20141105191505.GF27083@thunk.org>
References: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
 <1415203668.13212.2.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415203668.13212.2.camel@jarvis>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 05, 2014 at 05:07:48PM +0100, James Bottomley wrote:
> 
> OK, but I still don't understand how windows gets the partition table on
> there in the first place ... that must surely be some sort of guess the
> disk size hack.

99% of the time the partition table was provided by the drive
manufacturer; I would assume they have a way of doing that as a part
of their manufacturing processes that don't require an OS individually
running the equivalent of fdisk or gdisk on said drive.

		    	       	  	   - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
