From: Douglas Gilbert <dougg@torque.net>
Subject: Re: 2.5.48 modules problem
Date: Tue, 19 Nov 2002 10:40:43 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD97A7B.60200@torque.net>
References: <200211182217.gAIMHi904571@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

J.E.J. Bottomley wrote:
> dougg@torque.net said:
> 
>>Can't see other reports on this in the lists **. When I upgraded to lk
>>2.5.48, my kernel can't load modules. modprobe and friends all fail
>>with:
>>   QM_MODULES: Function not implemented 
> 
> 
> The entire method the kernel uses to construct and load modules changed in 
> 2.5.48.  You need Rusty's new module loader routines:
> 
> http://www.kernel.org/pub/linux/kernel/people/rusty/module-init-tools-0.7.tar.g
> z

James,
Thanks. I made some progress. Hope Rusty is going to write
some documentation, man pages, update the Changes file, etc.

The new modprobe doesn't seem to pass parameters (options)
properly, at least that is what I'm seeing with scsi_debug.

Enough other things are broken with 2.5.48 to force me back
to lk 2.4.18 .

Doug Gilbert


