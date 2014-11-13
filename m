From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 13 Nov 2014 18:14:14 +0100
Message-ID: <5464E6E6.3090606@laposte.net>
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net> <54647C10.4070506@laposte.net> <20141113142907.GB29354@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141113142907.GB29354@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

Hello Christoph,

I tested this commit :

7ae65c0f9646c29432b69580b80e08632e6cd813 scsi: convert target_busy to a=
n
atomic_t

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D7ae65c0f9646c29432b69580b80e08632e6cd813

there is no bug, boot process is ok whit this commit,

when I did the "git bisect" the first bad commit was Guenters' commit (
045065d8a300a37218c548e9aa7becd581c6a0e8 ), it seems that all commits
before 045065d8a300a37218c548e9aa7becd581c6a0e8 are ok,

you can find the log of the bisect here :

https://bugzilla.kernel.org/attachment.cgi?id=3D157211

Le 13/11/2014 15:29, Christoph Hellwig a =E9crit :
> Guenters commit just fixes the inversion from commit
>=20
> 71e75c97f97a9645d25fbf3d8e4165a558f18747 scsi: convert device_busy to=
 atomic_t
>=20
> Can you please test the commit before that:
> 74665016086615bbaa3fa6f83af410a0a4e029ee scsi: convert host_busy to a=
tomic_t
>=20
> and check if that works for you or not.
>=20
