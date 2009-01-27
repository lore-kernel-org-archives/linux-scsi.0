From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to
	VLC_SA_RECEIVE_CREDENTIAL
Date: Tue, 27 Jan 2009 14:10:36 -0800
Message-ID: <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
References: <1233093749.6442.97.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:41381 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752728AbZA0WLp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 17:11:45 -0500
In-Reply-To: <1233093749.6442.97.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Hi James,

Let me know if you need a fresh respin of this patch..  According to
spc4r17 section D.3.5, VLC_SA_RECEIVE_CREDENTIAL is the only
VARIABLE_LENGTH_CMD defined Service ACtion..

--nab

On Tue, 2009-01-27 at 14:02 -0800, Nicholas A. Bellinger wrote:
> >From 9147996b858bc44d8253929fe0cb4acfa9795986 Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Tue, 27 Jan 2009 13:29:49 -0800
> Subject: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to VLC_SA_RECEIVE_CREDENTIAL
> 
> This patch adds the VARIABLE_LENGTH_CMD Service Action code:
> VLC_SA_RECEIVE_CREDENTIAL and removes the incorrect CDB byte[0]
> opcode define RECEIVE_CREDENTIAL.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  include/scsi/scsi.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 93af6ce..aabd3d1 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -104,7 +104,6 @@
>  #define PERSISTENT_RESERVE_IN 0x5e
>  #define PERSISTENT_RESERVE_OUT 0x5f
>  #define VARIABLE_LENGTH_CMD   0x7f
> -#define RECEIVE_CREDENTIAL    0x7f // spc4r17 section 6.9 Table 204
>  #define REPORT_LUNS           0xa0
>  #define SECURITY_PROTOCOL_IN  0xa2
>  #define MAINTENANCE_IN        0xa3
> @@ -134,6 +133,9 @@
>  #define SERVICE_ACTION_IN     0x9e
>  /* values for service action in */
>  #define	SAI_READ_CAPACITY_16  0x10
> +/* values for VARIABLE_LENGTH_CMD service action codes
> + * see spc4r17 Section D.3.5, table D.7 and D.8 */
> +#define VLC_SA_RECEIVE_CREDENTIAL 0x1800
>  /* values for maintenance in */
>  #define MI_REPORT_IDENTIFYING_INFORMATION 0x05
>  #define MI_REPORT_TARGET_PGS  0x0a

