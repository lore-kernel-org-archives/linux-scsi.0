From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/2] libiscsi, iser: Adjust data_length to include protection
 information
Date: Tue, 03 Jun 2014 11:11:54 -0500
Message-ID: <538DF3CA.7030506@cs.wisc.edu>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com> <1401639581-20111-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401639581-20111-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/01/2014 11:19 AM, Sagi Grimberg wrote:
>  /**
> + * iscsi_adjust_dl - Adjust SCSI data length to include PI
> + * @sc: scsi command.
> + * @data_length: command data length.
> + *
> + * Adjust the data length to account for how much data
> + * is actually on the wire.
> + *
> + * returns the adjusted data length
> + **/
> +static unsigned
> +iscsi_adjust_dl(struct scsi_cmnd *sc, unsigned data_len)

Hey, one other comment. Could you rename this to iscsi_adjust_data_len
or iscsi_adjust_dlength? It is more common in the iscsi code to use
those names for data length.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
