From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: copy offload support in Linux - new system call needed?
Date: Mon, 19 Dec 2011 14:19:43 -0800
Message-ID: <4EEFB87F.9000104@zytor.com>
References: <4EE8F75F.6070800@gmail.com> <20111214195931.GC10664@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111214195931.GC10664@samba2>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 12/14/2011 11:59 AM, Jeremy Allison wrote:
>>
>> Can we resurrect this effort? Is copyfile() still a good way to go,
>> or should we look at other hooks?
> 
> Windows uses a COPYCHUNK call, which specifies the
> following parameters:
> 
> Definition of a copy "chunk":
> 
> hyper source_off;
> hyper target_off;
> uint32 length;
> 
> and an array of these chunks which is passed
> into their kernel.
> 
> This is what we have to implement in Samba.
> 

Could we do this by (re-)allowing sendfile() between two files?

	-hpa

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
