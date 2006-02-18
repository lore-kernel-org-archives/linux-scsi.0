From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 6092] New: drivers/scsi/pcmcia/aha152x_stub.c:
 aha152x_resume(): variable used before set
Date: Fri, 17 Feb 2006 21:10:49 -0800
Message-ID: <20060217211049.4368ff20.akpm@osdl.org>
References: <200602180209.k1I29meW030162@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:27604 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750809AbWBRFMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 00:12:19 -0500
In-Reply-To: <200602180209.k1I29meW030162@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>
Cc: linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6092
> 
>            Summary: drivers/scsi/pcmcia/aha152x_stub.c: aha152x_resume():
>                     variable used before set
>     Kernel Version: 2.6.16-rc4 and earlier
>             Status: NEW
>           Severity: high
>              Owner: scsi_drivers-aha152x@kernel-bugs.osdl.org
>          Submitter: bunk@stusta.de
> 
> 
> David Binderman <dcb314@hotmail.com> reported the following bug:
> 
> I just tried to compile the Linux Kernel version 2.6.11.12
> with the most excellent Intel C compiler. It said
> 
> drivers/scsi/pcmcia/aha152x_stub.c(313): remark #592: variable "tmp" is used
> before its value is set
>        tmp.device->host = info->host;
>        ^
> 
> This is clearly broken code, since the field tmp.device has not been
> initialised, and so isn't pointing to anything.
> 

(good luck - I've brought this to the scsi list a few times.  Unmaintained)
