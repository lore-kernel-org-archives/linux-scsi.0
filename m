From: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: copy offload support in Linux - new system call needed?
Date: Wed, 14 Dec 2011 14:22:07 -0500
Message-ID: <4EE8F75F.6070800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Back at LinuxCon Prague, we talked about the new NFS and SCSI commands that let 
us offload copy operations to a storage device (like an NFS server or storage 
array).

This got new life in the virtual machine world where you might want to clone 
bulky guest files or ranges of blocks and was driven through the standards 
bodies by vmware, microsoft and some of the major storage vendors. Windows8 has 
this functionality fully coded and integrated in the GUI, I assume vmware also 
uses it and there are some vendors who announced support at the SNIA SDC conference.

We had an active thread a couple of years back that came out of the reflink work 
and, at the time, there seemed to be moderately positive support for adding a 
new system call that would fit this use case (Joel Becker's copyfile()).

Can we resurrect this effort? Is copyfile() still a good way to go, or should we 
look at other hooks?

Thanks!

Ric



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
