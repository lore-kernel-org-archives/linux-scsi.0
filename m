From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 2/4] Fix for crash when bfa_itnim is NULL
Date: Fri, 30 Jan 2015 12:14:49 +1100
Message-ID: <CAGRGNgXz7uVtK93dUv7o8EmyLFd0dhGS+OnR+89ERrAFiY5XXg@mail.gmail.com>
References: <1422521757-18724-1-git-send-email-anil.gurumurthy@qlogic.com> <1422521757-18724-3-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:42441 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbbA3BPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 20:15:11 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so24544945wev.12
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2015 17:15:10 -0800 (PST)
In-Reply-To: <1422521757-18724-3-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Anil,

On Thu, Jan 29, 2015 at 7:55 PM,  <anil.gurumurthy@qlogic.com> wrote:
> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
>
> Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> ---
>  drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
>  drivers/scsi/bfa/bfad_im.c       |   26 ++++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
> index d823792..4631630 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
> @@ -2654,7 +2654,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
>
>         strncpy(hba_attr->node_sym_name.symname,
>                 port->port_cfg.node_sym_name.symname, BFA_SYMNAME_MAXLEN);
> -       strcpy(hba_attr->vendor_info, "BROCADE");
> +       strcpy(hba_attr->vendor_info, "QLogic");

Shouldn't this be in the next patch?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
