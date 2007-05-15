From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: Asynchronous scsi scanning
Date: Tue, 15 May 2007 17:30:50 +0100
Message-ID: <4649E03A.1090004@simon.arlott.org.uk>
References: <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com> <1179073116.3723.45.camel@mulgrave.il.steeleye.com> <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com> <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com> <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com> <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:36107 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbXEOQbE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2007 12:31:04 -0400
In-Reply-To: <20070515120228.GI10562@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org

On 15/05/07 13:02, Matthew Wilcox wrote:
> On Tue, May 15, 2007 at 12:26:29PM +0100, Simon Arlott wrote:
>> I've already suggested a sysfs attribute - or something equivalent - would
>> be much better. It's just one function that a user might want to run multiple
>> times (e.g. after adding scsi devices?) - why should loading a module be used
>> for this?
> 
> It's easy to suggest a sysfs attribute.  What you've failed to do is
> suggest the pathname of the sysfs attribute, the contents of it, or the
> semantics of it (read-only?  read-write?  write-only?  blocking?)

I would assume that should be up to SCSI users/maintainer(s). The only thing 
I use the SCSI driver for is usb-storage/ATAPI.

> My personal favourite would be to add a new verb to /proc/scsi/scsi, but
> James dislikes that idea.
> 
> I'd *really* like to hear from distro people.  What is the most
> convenient way for you to implement "load all the scsi modules, then
> wait until all devices are found"?  James and I had thought that loading
> a new module would be the easiest way for you, but it seems inconvenient
> for you.

It's inconvenient for people who *don't* use it to be unable to stop the 
module being built and installed.

-- 
Simon Arlott
