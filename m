From: Luben Tuikov <luben@splentec.com>
Subject: Re: Fwd: Patch - SCSI host numbers - please apply
Date: Wed, 19 Jun 2002 12:26:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D10B0BA.17090E63@splentec.com>
References: <200206171604.57115.nahshon@actcom.co.il> <200206181514.52827.nahshon@actcom.co.il> <3D0FA398.8DA6C959@splentec.com> <200206190303.45188.nahshon@actcom.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: nahshon@actcom.co.il
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi <linux-scsi@vger.kernel.org>

Itai Nahshon wrote:

> I suspect there
> is something wrong with your configuration or with the
> way that you run your tests.

What could be wrong with my configuration? Anything specific
that you have in mind?

What do you mean ``they way you run your tests''?
Could you please elaborate...

The second time you loaded the module did you get
1 to 100 or 31 to 131?
 
> My configuration:
> RedHat 7.2, non-SMP. All the updates from RedHat applied +KDE-3.0.
> Relevant RPMS:
>         gcc-2.96-98
>         cpp-2.96-98
>         binutils-2.11.90.0.8-11
>         modutils-2.4.13-0.7.1

My configuration is as follows (RH7.1):
- kernel: 2.4.18
- gcc 3.0.4 
Reading specs from /usr/local/lib/gcc-lib/i686-pc-linux-gnu/3.0.4/specs
Configured with: ../gcc-3.0.4/configure --host=i686-pc-linux-gnu --with-gnu-as --with-gnu-ld
--disable-win32-registry --enable-threads=posix
Thread model: posix
gcc version 3.0.4
- GNU ld version 2.10.91 (with BFD 2.10.91.0.2)
- modinfo (Linux modutils) 2.4.2

This is very strange, maybe we should get someone else to
independently test this? (scsi_reg.o with and without your patch
on a 2.4.18.)

Anyone?

-- 
Luben
