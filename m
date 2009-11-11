From: Jeff Smith <lkml.sepix@code.wastedcycles.net>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_device_type
Date: Wed, 11 Nov 2009 21:22:41 +0000
Message-ID: <4AFB2B21.4030103@code.wastedcycles.net>
References: <4AFAFF94.4050500@code.wastedcycles.net> <1257970134.11985.20.camel@mulgrave.site>
Reply-To: lkml.sepix@code.wastedcycles.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thinkula.hx3.notconnected.net ([192.207.141.44]:38884 "EHLO
	sardonic.codimension.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823AbZKKVWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 16:22:41 -0500
In-Reply-To: <1257970134.11985.20.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-11-11 at 18:16 +0000, Jeff Smith wrote:
>> The following patch fixes the 'make headers_check' warning:
>>     include/scsi/scsi.h:288: userspace cannot call function or variable defined in the kernel
>> It is similar to a patch from Jaswinder Singh Rajput back in July, which did not initially compile.
[..snip..]
>> A similar patch for the scsi_command_size code should be feasible, but a code search reveals some 
[..snip..]
 
> Actually, there are several other problems like this that need
> fixing ... and for which we have patches submitted.  

Thanks for the hint -- I've found some of them now! Sorry! (I am not
on linux-scsi, so I have a bit of catching-up to do.)

> The debating point
> is whether we actually want to clean scsi.h and the allied headers up
> enough so we can ask Ulrich actually to use them for glibc ... and where
> the resulting headers should be placed.  So far we have no consensus on
> this.

If there is no agreement on asking Ulrich or on ultimate filestore location, the
question is whether meanwhile it's worth deploying the minimal cleaning necessary
to avoid warnings and other known small difficulties (as mentioned 
in eg. Michael S. Tsirkin's patchset). I assume you think that the debate 
will resolve itself in due course, so a minor stall now is preferable?
 
> Personally, I think a line by line comparison of the scsi.h in Ulrich's
> glibc tree and ours making it identical and shoving all the non kernel
> stuff into other headers might be the way to go .. but others have
> disagreed in the past.

Personally I agree with your approach, but I wouldn't want to do actual
work on it if it's unlikely to get deployed.

Jeff

> James
> 
> 

