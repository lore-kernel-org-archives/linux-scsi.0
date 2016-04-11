From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Mon, 11 Apr 2016 17:29:03 -0400
Message-ID: <yq1vb3n25sw.fsf@sermon.lab.mkp.net>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com>
	<yq137qw6bzz.fsf@sermon.lab.mkp.net>
	<888890380.28014192.1460104289837.JavaMail.zimbra@redhat.com>
	<1460119192.25335.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460119192.25335.40.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org> (Ewan
	D. Milne's message of "Fri, 08 Apr 2016 08:39:52 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ewan D. Milne" <emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

Ewan> In the upstream kernel queue_max_sectors_store() does not permit
Ewan> you to set a value larger than the device-imposed limit.  This
Ewan> value, stored in q->limits.max_dev_sectors, is not visible via the
Ewan> block queue sysfs interface.

I should refresh the patch that exposes that. There were a few comments
and I never got around to rolling those in.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
