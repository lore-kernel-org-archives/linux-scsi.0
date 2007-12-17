From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] drivers/scsi/: Spelling fixes
Date: Mon, 17 Dec 2007 13:58:30 -0600
Message-ID: <4766D4E6.7000002@cs.wisc.edu>
References: <1197920439-5455-8-git-send-email-joe@perches.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1197920439-5455-8-git-send-email-joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi-help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi-unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Adaptec OEM Raid Solutions <aacraid-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, Andrew Vasquez <linux-driver-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Brian King <brking-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Jeffery <ipslinux-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "James E.J. Bottomley" <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, James Smart <james.smart-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Neela Syam Kolli <megaraidlinux-M7mHMAq9Yzo@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Joe Perches wrote:
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 57ce225..3cc21f5 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1121,7 +1121,7 @@ iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
>   * iscsi_sendhdr - send PDU Header via tcp_sendpage()
>   * @conn: iscsi connection
>   * @buf: buffer to write from
> - * @datalen: lenght of data to be sent after the header
> + * @datalen: length of data to be sent after the header
>   *
>   * Notes:
>   *	(Tx, Fast Path)
> @@ -1724,7 +1724,7 @@ send_hdr:
>   *	XMSTATE_BIT_SOL_DATA     - send solicit data
>   *
>   *iscsi_tcp_ctask_xmit
> - *	XMSTATE_BIT_IMM_DATA     - xmit managment data (??)
> + *	XMSTATE_BIT_IMM_DATA     - xmit management data (??)
>   **/
>  static int
>  iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)

Olaf rewrote this code and it will not exist when James merges the 
patches, so you can drop the iscsi bits.

--~--~---------~--~----~------------~-------~--~----~
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To unsubscribe from this group, send email to open-iscsi-unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi
-~----------~----~----~----~------~----~------~--~---
