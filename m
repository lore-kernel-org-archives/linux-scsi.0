From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
Date: Sun, 18 Dec 2011 08:45:40 -0600
Message-ID: <1324219540.3091.28.camel@dabdike.int.hansenpartnership.com>
References: <1321572864-23628-1-git-send-email-richard@nod.at>
	 <4EEDFC16.90303@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EEDFC16.90303@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-12-18 at 15:43 +0100, Richard Weinberger wrote:
> Am 18.11.2011 00:34, schrieb Richard Weinberger:
> > scsi_dh_attach() should return a negative value on error.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  include/scsi/scsi_dh.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> > index e3f2db2..e07ab10 100644
> > --- a/include/scsi/scsi_dh.h
> > +++ b/include/scsi/scsi_dh.h
> > @@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char *name)
> >  }
> >  static inline int scsi_dh_attach(struct request_queue *req, const char *name)
> >  {
> > -	return SCSI_DH_NOSYS;
> > +	return -SCSI_DH_NOSYS;
> >  }
> >  static inline void scsi_dh_detach(struct request_queue *q)
> >  {
> 
> James,
> 
> can you please pickup this patch?

It still needs an ack from rdac people (other one just got overlooked).

James
