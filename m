From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Sun, 21 Jun 2015 15:03:31 +0800
Message-ID: <CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 21 June 2015 at 08:20, Martin K. Petersen <martin.petersen@oracle.com> wrote:
> It is a SATA-attached drive, it has no block limits VPD. What you are
> seeing is information prepared by libata's SATL.
>
> Because if the vendor got these trivial values wrong there is little to
> no chance that they implemented discard correctly in their firmware.

I don't get it. So there's a chance that the VPDs is not purely from
the hardware? Then how can I differentiate them? But then you said
"the vendor got these trivial values wrong", so were you talking about
this drive or just for real SCSI drives?
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
