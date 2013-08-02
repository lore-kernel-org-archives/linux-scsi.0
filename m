From: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Fri, 02 Aug 2013 16:11:05 +0200
Message-ID: <1375452665.2138.17.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1308020954120.1176-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1308020954120.1176-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux PM List <linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-08-02 at 09:54 -0400, Alan Stern wrote:
> On Fri, 2 Aug 2013, Oliver Neukum wrote:
> 
> > On Thu, 2013-08-01 at 11:53 -0400, Alan Stern wrote:
> > > On Thu, 1 Aug 2013, Oliver Neukum wrote:
> > > 
> > > > On Wed, 2013-07-31 at 11:13 -0400, Alan Stern wrote:
> > > > 
> > > > > More importantly, if we already know that the medium is not present or
> > > > > has been changed since it was last used, then there's no reason to call
> > > > > sd_sync_cache() at all.
> > > > 
> > > > Like this?
> > > 
> > > Yes, I like this a lot better, except I would put the test for 
> > > !sdkp->media_present in sd_suspend_common() -- no need to print the
> > 
> > But your observation that it makes no sense while no medium is present
> > is valid whatever be the reason for wanting to flush.
> 
> So do the test in both places.

Code duplication for what reasons?

	Regards
		Oliver



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
