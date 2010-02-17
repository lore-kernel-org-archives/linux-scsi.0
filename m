From: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Maximum data size in a single transfer for MS driver
Date: Wed, 17 Feb 2010 18:07:50 +0530
Message-ID: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Dear All,

What is  the number of maximum sectors that SCSI can send to MS driver
in a single data transfer?

I changed the max_sectors in struct scsi_host_template
usb_stor_host_template structure to 2048. Still, SCSI is sending 1024
sectors (512 KB) in a single data transfer.
I know that my device supports 1 MB data in a sigle transfer.  How can
I change this to 1 MB?

Thanks and Regards,
RD
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
