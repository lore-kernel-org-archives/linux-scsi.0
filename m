From: Dmitry Torokhov <dtor_core@ameritech.net>
Subject: Re: [PATCH scsi-misc 2/2][RESEND] megaraid_sas: LSI Logic MegaRAID SA S RAID Driver
Date: Sat, 4 Jun 2005 02:34:04 -0500
Message-ID: <200506040234.05451.dtor_core@ameritech.net>
References: <0E3FA95632D6D047BA649F95DAB60E57060CCEFA@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp810.mail.sc5.yahoo.com ([66.163.170.80]:7065 "HELO
	smtp810.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261282AbVFDHeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Jun 2005 03:34:11 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CCEFA@exa-atlanta>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Christoph Hellwig' <hch@infradead.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Ju, Seokmann" <sju@lsil.com>

On Saturday 04 June 2005 01:13, Bagalkote, Sreenivas wrote:
> +/**
> + * megasas_issue_polled -	Issues a polling command
> + * @instance:			Adapter soft state
> + * @cmd:			Command packet to be issued 
> + *
> + * For polling, MFI requires the cmd_status to be set to 0xFF before
> posting.
> + */
> +static int
> +megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd
> *cmd)

Hi,

I am sorry to say that, but it looks like this one arrived line-wrapped
again.

-- 
Dmitry
