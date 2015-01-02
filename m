From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH v2] drivers: scsi: megaraid: Add "megaraid_sas_internal.h" for internal shared functions using
Date: Fri, 2 Jan 2015 13:03:29 +0800
Message-ID: <5A7713F0-DDDF-4985-BBDA-66F4D428BAD1@gmail.com>
References: <548DB542.7000400@gmail.com> <20141230124511.GB24088@infradead.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141230124511.GB24088@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "megaraidlinux@lsi.com" <megaraidlinux@lsi.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Could you provide more detail for it, then I can make patch v3 (or I ha=
ve no any idea
about it).

Thanks

=B7=A2=D7=D4=CE=D2=B5=C4 iPad

> =D4=DA 2014=C4=EA12=D4=C230=C8=D5=A3=AC=CF=C2=CE=E78:45=A3=ACChristop=
h Hellwig <hch@infradead.org> =D0=B4=B5=C0=A3=BA
>=20
>> On Mon, Dec 15, 2014 at 12:05:22AM +0800, Chen Gang wrote:
>> For shared inline functions crossed source files, better to let it a=
s
>> "static inline" in a header file. For extern functions, better to
>> declare them in header file.
>=20
>=20
> This one doesn't apply.
