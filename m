From: Ravish Tayal <ravish.tayal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Query to optimize PageCache size in system
Date: Wed, 13 May 2009 20:35:52 +0530
Message-ID: <e42309110905130805r135c3373xa6ecda0e45180d34@mail.gmail.com>
References: <e42309110905130732xf4313a6qba1f30a2d89728be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e42309110905130732xf4313a6qba1f30a2d89728be-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ravish.tayal-AX/FTzQb/nxWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi
I am looking for help to reduce the number of cached pages in the
system. I am using 2.6.12 linux kernel on ARM processor.for my
embedded USB mass storage application.

As in the system when I do read/write operatation from the USB disk
attached to my development boards, I observed steep increase in the
(/proc/meminfo)
Buffers:         48 kB           [From 0KB]
Cached:        17184 kB      [From 8100 KB]


I have few queries :

1. MemInuse = (MemTotal - Memfree) , why it is not equal to (Active
Pages + Inactive Pages+mapped pages + slab + page Tables)
2. As per my understanding  slab page numbers should match exactly
with the total page output of /proc/slabinfo is it correct ?
3. Is there any provision in linux kernel through which I can restrict
the new page allocation for disk operation to not to be added in the
page-cache  ?
4. If I open the file with O_DIRECT Flag would page_cache be avoided,
irrespective it is file read or File write operations?
5. Is pdflush parameters dirty_background_ratio and dirty_ratio would
help be in file read operations also to reduce the page cache eneries.
6. As buffer cached enteries increases to only 48K, does it means
mostly page cache are added by filesystem while actual disk operation
are actual very few.

with regards
Ravish Tayal
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
