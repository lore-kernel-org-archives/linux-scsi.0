From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] Remove __NO_VERSION__ from 2.4
Date: 12 Aug 2002 11:18:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1029147489.16216.126.camel@irongate.swansea.linux.org.uk>
References: <20020811210612.B18882C0DD@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020811210612.B18882C0DD@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@samba.org>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Kai Germaschewski <kai.germaschewski@gmx.de>, Karsten Keil <kkeil@suse.de>, braam@clusterfs.com, davem@redhat.com, dledford@redhat.com, dwmw2@redhat.com, faith@redhat.com, greg@kroah.com, hpa@zytor.com, jaharkes@cs.cmu.edu, jffs-dev@axis.com, jhartmann@precisioninsight.com, laforge@gnumonks.org, linux-scsi@vger.kernel.org, mac@melware.de, perex@suse.cz, schwidefsky@de.ibm.com, trond.myklebust@fys.uio.no

On Mon, 2002-08-12 at 02:50, Rusty Trivial Russell wrote:
> [ BTW: rustcorp.com.au temporarily not resolving, using samba.org address ]
> 
> From:  Keith Owens <kaos@ocs.com.au>
> 
>   #define __NO_VERSION__ has not been required since 2.3 days.  Trivial
>   change to remove all references to __NO_VERSION__, it just hits a lot
>   of files.

This seems to touch files whose authors have explicitly asked people not
to mangle 2.2/2.4 compatibility. Surely 2.5 is the place for this kind
of stuff. Its a change that has no effect other than making sure patches
don't apply and 2.2/2.4 compat code breaks on people.

