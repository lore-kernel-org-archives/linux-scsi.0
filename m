From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: 2.5.48 modules problem
Date: Mon, 18 Nov 2002 16:17:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211182217.gAIMHi904571@localhost.localdomain>
References: <dougg@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA22155
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2002 14:17:48 -0800
In-Reply-To: Message from Douglas Gilbert <dougg@torque.net>
   of "Tue, 19 Nov 2002 08:58:14 +1100." <3DD96276.5050005@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

dougg@torque.net said:
> Can't see other reports on this in the lists **. When I upgraded to lk
> 2.5.48, my kernel can't load modules. modprobe and friends all fail
> with:
>    QM_MODULES: Function not implemented 

The entire method the kernel uses to construct and load modules changed in 
2.5.48.  You need Rusty's new module loader routines:

http://www.kernel.org/pub/linux/kernel/people/rusty/module-init-tools-0.7.tar.g
z

For the record, I still can't get quite a few modules to load even with this.

James


