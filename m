From: christophe.varoqui@free.fr
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.3.0
Date: Fri,  8 Oct 2004 14:49:02 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097239742.41668cbec3b65@imp1-q.free.fr>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <20041007200143.GA9667@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041007200143.GA9667@osdl.org>
To: device-mapper development <dm-devel@redhat.com>, Dave Olien <dmo@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Selon Dave Olien <dmo@osdl.org>:

>
> Christophe,
>
> I downloaded your new multipath tools, and they seem to have solved a problem
> I was having with the previous version.
>
> The only difficulty I had was with the new klibc version (klibc-0.181).
> For i386 architecture, it compiles by default with -mregparm=3, to
> pass arguments in registers.
>
good catch.

I think the correct fix is to follow the klibc rules, ie :
CFLAGS += ${OPTFLAGS} in Makefile.inc

I'll release a new tarball soon to correct this.

thanks,
cvaroqui
--
