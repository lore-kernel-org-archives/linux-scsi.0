From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Thu, 1 May 2003 19:44:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030501234455.GA8163@linnie.riede.org>
References: <3EB11AD3.2070503@torque.net> <20030501155225.7df14e51.rddunlap@osdl.org> <3EB1ADF3.5080008@torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp02781107pcs.eatntn01.nj.comcast.net ([68.85.61.149]:44528
	"EHLO linnie.riede.org") by vger.kernel.org with ESMTP
	id S262776AbTEAXar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2003 19:30:47 -0400
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.8/8.12.8) with ESMTP id h41Nit3x012411
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2003 19:44:55 -0400
Content-Disposition: inline
In-Reply-To: <3EB1ADF3.5080008@torque.net>; from dougg@torque.net on Thu, May 01, 2003 at 19:29:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.05.01 19:29 Douglas Gilbert wrote:
> Randy.Dunlap wrote:
> <snip/>
> 
>> Hi Doug,
>> 
>> I have ATAPI CD-ROM as hdc and CD-RW as hdd.  I boot with
>> "hdd=icd-scsi ide-scsi.debug=3".  Is that right/OK so far?
>> If not, what should it be?
> 
> Randy,
> I thought so but it's not picking "ide-scsi.debug=3" up:
> 
> > Kernel command line: auto BOOT_IMAGE=lin2568isc ro root=304
>   >  devfs=nomount hdd=ide-scsi ide-scsi.debug=3 console=tty0
>   >  console=ttyS0,38400n8 debug
> > ide_setup: hdd=ide-scsi
> > ide_setup: ide-scsi.debug=3 -- BAD OPTION
> 
> The code uses Rusty's moduleparam.h and it worked
> for me with scsi_debug. [It is some time since I checked
> scsi_debug built-in.] Could you try "idescsi.debug=3"
> (i.e. drop the hyphen).

I have on occasion noticed that the kernel thinks ide-scsi is
called ide_scsi (i.e. with an underscore). You could try that too.

Success, Willem Riede.
