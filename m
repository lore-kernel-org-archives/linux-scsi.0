From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 27/39] Annotate hardware config module parameters in drivers/scsi/
Date: Wed, 05 Apr 2017 15:33:00 +0100
Message-ID: <24495.1491402780@warthog.procyon.org.uk>
References: <alpine.LNX.2.00.1612020903450.24840@nippy.intranet> <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk> <148059559339.31612.16180464424786438715.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1612020903450.24840@nippy.intranet>
Content-ID: <24494.1491402780.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>, Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, gnomes@lxorguk.ukuu.org.uk, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, minyard@acm.org, "Juergen E. Fischer" <fischer@norbit.de>, Dario Ballabio <ballabio_dario@emc.com>
List-Id: linux-scsi@vger.kernel.org

Finn Thain <fthain@telegraphics.com.au> wrote:

> I can see how base addresses and IO ports are relevant, but the irq 
> parameter changes below don't protect the kernel image AFAICT. What's the 
> rationale for those changes? I think it should be stated here.

Easier grepping for one.  But I'm also currently preventing the changing of
any hardware parameters.  If a driver refuses to share an irq, you could use
it to deprive another driver of the ability to get an irq at all.

David
