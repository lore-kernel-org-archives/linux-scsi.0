From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [RESEND][PATCH 4/4] scsi_dh: code cleanup and remove the references to scsi_dev_info
Date: Wed, 30 Nov 2011 18:20:39 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910AB8C13@RTPMVEXC1-PRD.hq.netapp.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DBE66@RTPMVEXC1-PRD.hq.netapp.com> <20111130225211.GA18168@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:44788 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab1K3XU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2011 18:20:59 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20111130225211.GA18168@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, hare@suse.de

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Wednesday, November 30, 2011 4:52 PM
> To: Moger, Babu
> Cc: Linux SCSI Mailing list; device-mapper development; hare@suse.de
> Subject: Re: [RESEND][PATCH 4/4] scsi_dh: code cleanup and remove the
> references to scsi_dev_info
> 
> On Thu, Nov 03 2011 at 11:52am -0400,
> Moger, Babu <Babu.Moger@netapp.com> wrote:
> 
> > All the handlers have implemented the match function(look at patch 1,
> 2, 3).
> > We don't need to use scsi_dev_info any more for matching purposes.
> > Cleaning up the scsi_dh code.
> >
> > FYI..
> > Match function was originally implemented by this
> >
> > http://www.spinics.net/lists/linux-scsi/msg54284.html
> > or
> > http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-
> 2.6.git;a=commit;h=6c3633d08acf514e2e89aa95d2346ce9d64d719a
> >
> > Signed-off-by: Babu Moger <babu.moger@netapp.com>
> 
> Looks good, effectively reverts commit 940d7faa481
> 
> But SCSI_DEVINFO_DH can be removed too:

Looks good. I missed it. Thanks Mike..I can resend this patch 4/4.

 
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index a6ebf4c..1fbf7c7 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -44,7 +44,6 @@ static inline void scsi_log_completion(struct
> scsi_cmnd *cmd, int disposition)
>  enum {
>  	SCSI_DEVINFO_GLOBAL = 0,
>  	SCSI_DEVINFO_SPI,
> -	SCSI_DEVINFO_DH,
>  };
> 
>  extern int scsi_get_device_flags(struct scsi_device *sdev,
