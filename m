From: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: RE: copy offload support in Linux - new system call needed?
Date: Thu, 15 Dec 2011 11:11:38 -0500
Message-ID: <1323965498.14317.13.camel@lade.trondhjem.org>
References: <4EE8F75F.6070800@gmail.com>
	 <20111214192739.GN2203@ZenIV.linux.org.uk> <4EE8FC2E.3010207@gmail.com>
	 <20111214222723.GD7623@fieldses.org>
	 <1323961140.14317.2.camel@lade.trondhjem.org>
	 <D3F292ADF945FB49B35E96C94C2061B91516E391@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B91516E391-2s2rCY1e8UXHBhWB4kaBDUEOCMrvLtNR@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Loke, Chetan" <Chetan.Loke-Wi0MfyythtRWk0Htik3J/w@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-15 at 11:08 -0500, Loke, Chetan wrote: 
> > How would the server know? I suggest we deal with this by adding an
> > ioctl() to allow the application to poll for progress: I'm assuming now
> 
> Why not support something like the async-iocb?

You could, but that would tie copyfile() to the aio interface which was
one of the things that I believe Al was opposed to when we discussed
this at LSF/MM-2010.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
www.netapp.com

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
