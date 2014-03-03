From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: v3.14-rc2+ WARNING: CPU: 0 PID: 24108 at fs/sysfs/group.c:216
 sysfs_remove_group+0xa3/0xb0()
Date: Mon, 3 Mar 2014 16:44:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1403031641231.1373-100000@iolanthe.rowland.org>
References: <1392666936.2198.23.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392666936.2198.23.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Ronald <ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal =?UTF-8?Q?=EF=BF=BDmucr?= <msmucr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 17 Feb 2014, James Bottomley wrote:

> > You can tell by the way the stack trace doesn't mention USB at all.  In 
> > fact, this is a known SCSI problem.  It has been fixed by these two 
> > patches:
> > 
> > 	http://marc.info/?l=linux-scsi&m=139031645920152&w=2
> > 	http://marc.info/?l=linux-scsi&m=139031650720168&w=2
> > 
> > If these patches have appeared in any git repositories yet, I don't 
> > know where.
> > 
> > James, what happened to those two target-reap-infrastructure patches?  
> > They don't seem to have reached linux-next yet, and I can't find them 
> > in your SCSI repository on git.kernel.org.
> 
> Yes, I'm just about to build it.  I usually start at -rc1, but got a
> little behind because of pressure of work.  I need them to go through a
> full regression cycle just to make sure there aren't any new bugs, but
> then they'll get backported to the stable kernels.

James, these two patches appear still not to be merged in any of your 
branches on git.kernel.org.  Will they get there in time for the next 
merge window?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
