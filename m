From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Thu, 07 Jan 2010 14:15:11 -0500
Message-ID: <4B4632BF.4070806@pobox.com>
References: <4B3BDB66.6000008@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B3BDB66.6000008@googlemail.com>
Sender: linux-ide-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/30/2009 05:59 PM, Ren=E9 Bolldorf wrote:
> We don't need this ;-).
>
> Best regards Ren=E9 Bolldorf & a happy new year in advance.
>
> --- ./drivers/ata/libata-eh.c 2009-12-30 23:44:05.578988545 +0100
> +++ ./drivers/ata/libata-eh.c 2009-12-30 23:45:06.991987607 +0100
> @@ -1505,9 +1505,6 @@ static unsigned int atapi_eh_request_sen
>
> DPRINTK("ATAPI request sense\n");
>
> - /* FIXME: is this needed? */
> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);

I need a little bit more detail than an unqualified statement...  Did=20
you audit all paths leading to this code point?

	Jeff


