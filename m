From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: Thu, 08 Aug 2002 12:12:51 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020808032826.3478A455C@lists.samba.org>
References: <1028720225.18156.246.camel@irongate.swansea.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "07 Aug 2002 12:37:05 +0100."
             <1028720225.18156.246.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org

In message <1028720225.18156.246.camel@irongate.swansea.linux.org.uk> you write
:
> On Wed, 2002-08-07 at 04:59, Rusty Trivial Russell wrote:
> > [ Removes the unused warning, and since qla1280_do_dpc is only called when
> >   version < 2.1.95 anyway, makes the whole thing conditional ]
> > 
> 
> General policy - rip out version ifdefs unless the driver has a
> maintainer who actively objects ?

Hm, I wouldn't accept a patch to Trivial which just ripped them out.
If it was part of a larger cleanup, then sure.  In this case it
doesn't change code, it just simplifies it as well as the easiest way
of fixing the warning.

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
