From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Thu, 07 Jan 2010 21:40:18 +0100
Message-ID: <4B4646B2.6050103@googlemail.com>
References: <4B3BDB66.6000008@googlemail.com> <4B4632BF.4070806@pobox.com> <4B46453E.1060206@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B46453E.1060206@googlemail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/07/10 21:34, Ren=E9 Bolldorf wrote:
> On 01/07/10 20:15, Jeff Garzik wrote:
>> I need a little bit more detail than an unqualified statement... Did
>> you audit all paths leading to this code point?
>
> Yes, and my two systems running fine with the patch, no oops or panic=
's.

Sry forgot that:
	/* initialize sense_buf with the error register,
	 * for the case where they are -not- overwritten
	 */
	sense_buf[0] =3D 0x70;
	sense_buf[2] =3D dfl_sense_key;

So i think memset() is not needed and works very well without it.
