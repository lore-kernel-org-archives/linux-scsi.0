From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 05/11] IB/srp: destroy and recreate QP and CQs on each
 connection
Date: Mon, 26 Nov 2012 19:57:36 +0100
Message-ID: <50B3BBA0.1050302@acm.org>
References: <cover.1353903448.git.dillowda@ornl.gov> <8fa9a268ec4dc587970161efe94968f3263aad3b.1353903448.git.dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8fa9a268ec4dc587970161efe94968f3263aad3b.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Ishai Rabinovitz <ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Michael S. Tsirkin" <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/26/12 05:44, David Dillow wrote:
> From: Ishai Rabinovitz <ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
>
> HW QP FATAL errors persist over a reset operation, but we can recover
> from that by recreating the QP and associated CQs for each connection.
> Creating a new QP/CQ also completely forecloses any possibility of
> getting stale completions or packets on the new connection.

[ ... ]

This looks like a more elegant way than what I had came up with ("Make 
srp_disconnect_target() wait for IB completions") so I'm fine with this 
patch, and with the next one too.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
