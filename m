From: li jianyun <jianyunff@gmail.com>
Subject: Re: [PATCH v2] Add Marvell UMI driver
Date: Wed, 11 May 2011 21:17:25 +0800
Message-ID: <BANLkTi=PyObf4pm7xF8jT7hcDgpJVrCdSg@mail.gmail.com>
References: <1304943577-2876-1-git-send-email-jianyunff@gmail.com> <8883108.HpZuVnkiNA@donald.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8883108.HpZuVnkiNA@donald.sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Rolf Eike Beer <eike@sf-mail.de>
Cc: James.Bottomley@suse.de, Jianyun Li <jyli@marvell.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2011/5/10 Rolf Eike Beer <eike@sf-mail.de>:
>
>
>> +static unsigned char tag_is_empty(struct tag_stack *st)
>> +{
>> + =A0 =A0 if (st->top =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +}
>
> The return value should be bool. But I don't think this function is w=
orth it,
> I can only find one place where it is used at all.
>

it may be easy to understand. so I am not modify it.
