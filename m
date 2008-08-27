From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Wed, 27 Aug 2008 10:21:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808271019450.2498-100000@iolanthe.rowland.org>
References: <20080826231301.aac6f0e5.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080826231301.aac6f0e5.ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 26 Aug 2008, Antonio Ospite wrote:

> Hi,
> 
> is the fix going to be merged? I haven't seen it in rc4-git series.

Sorry, it slipped my mind.  I'll submit it shortly.  However it may not 
be accepted right away, since it affects a very important and difficult 
part of the SCSI stack.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
