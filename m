From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: 07 Aug 2002 12:37:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1028720225.18156.246.camel@irongate.swansea.linux.org.uk>
References: <20020807043057.395C74BD6@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020807043057.395C74BD6@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org

On Wed, 2002-08-07 at 04:59, Rusty Trivial Russell wrote:
> [ Removes the unused warning, and since qla1280_do_dpc is only called when
>   version < 2.1.95 anyway, makes the whole thing conditional ]
> 

General policy - rip out version ifdefs unless the driver has a
maintainer who actively objects ?

