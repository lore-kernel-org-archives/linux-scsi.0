From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Cant write to max_sectors_kb on 4.5.0 SRP target
Date: Thu, 7 Apr 2016 19:49:58 -0700
Message-ID: <57071C56.7070500@sandisk.com>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <302427900.27942894.1460063713447.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/07/16 14:16, Laurence Oberman wrote:
> I have been testing the SRP initiator code to an LIO array here and
 > part of the testing requires me to set the max_sectors_kb size to
 > get 4k I/O's.
                                                                        .
Hello Laurence,

Have you already tried to set the max_sect parameter in 
/etc/srp_daemon.conf (assuming you are using srptools >= 1.0.3 for SRP 
login) ? Additionally, writing something like "options ib_srp 
cmd_sg_entries=255" into /etc/modprobe.d/ib_srp.conf will increase the 
maximum SRP transfer size.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
