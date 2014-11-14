From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Fri, 14 Nov 2014 17:30:36 +0100
Message-ID: <54662E2C.5020309@laposte.net>
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net> <54647C10.4070506@laposte.net> <20141113142907.GB29354@infradead.org> <5464E6E6.3090606@laposte.net> <20141113175402.GA27327@infradead.org> <546536EA.4070705@laposte.net> <20141114073214.GA1879@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141114073214.GA1879@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

Hello Christoph,

I did the new bisect,

the first bad commit is :

74665016086615bbaa3fa6f83af410a0a4e029ee
scsi: convert host_busy to atomic_t

you can find the bisect log here :

https://bugzilla.kernel.org/attachment.cgi?id=3D157621


Le 14/11/2014 08:32, Christoph Hellwig a =E9crit :
> On Thu, Nov 13, 2014 at 11:55:38PM +0100, Barto wrote:
>> it's interesting, with this commit
>> 74665016086615bbaa3fa6f83af410a0a4e029ee I have the bug :
>>
>> scsi: convert host_busy to atomic_t :
>=20
> At this point we'll need a bisction between v3.16 as the last good
> point, and 74665016086615bbaa3fa6f83af410a0a4e029ee as the known bad
> point.
>=20
