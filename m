From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 16:04:52 +0000
Message-ID: <1488989079.2813.1.camel@sandisk.com>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
         <20170308151113.GB27450@infradead.org>
         <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
Content-Language: en-US
Content-ID: <8CFF799EEBCF3044BC828CDCC5B0A31D@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-03-08 at 21:29 +0530, Kashyap Desai wrote:
> Also one more fault I can generate using below sg_raw command -
>=20
> "sg_raw -r 32k /dev/sdx 28 00 01 4f ff ff 00 00 08 00"
>=20
> Provide more scsi data length compare to actual SG buffer. Do you suggest
> such SG_IO interface vulnerability is good to be captured in driver.

That's not a vulnerability of the SG I/O interface. A SCSI device has to se=
t
the residual count correctly if the SCSI data length does not match the siz=
e
of the data buffer.

Bart.=
