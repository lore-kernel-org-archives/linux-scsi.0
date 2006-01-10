From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: SG_GET_ACCESS_COUNT ioctl problem
Date: Tue, 10 Jan 2006 04:50:32 -0500
Message-ID: <43C38368.5040101@cfl.rr.com>
References: <43C119A0.8070304@cfl.rr.com> <43C36EFA.1040800@torque.net> <43C37299.6050301@cfl.rr.com> <43C37932.90006@torque.net>
Reply-To: dmarkh@cfl.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-04-smtplb.tampabay.rr.com ([65.32.5.134]:7918 "EHLO
	ms-smtp-04.tampabay.rr.com") by vger.kernel.org with ESMTP
	id S1750736AbWAJJuf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 04:50:35 -0500
Received: from [10.10.10.100] (158.244.118.70.cfl.res.rr.com [70.118.244.158])
	by ms-smtp-04.tampabay.rr.com (8.12.10/8.12.7) with ESMTP id k0A9oVVq000799
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 04:50:32 -0500 (EST)
In-Reply-To: <43C37932.90006@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:

> Mark,
> In the lk 2.6 series you can open a disk directly
> (e.g. /dev/sda) and send it SCSI commands using the
> SG_IO ioctl. The situation is the same if you open
> the corresponding sg device and send SCSI commands.
> 
> What is important is which SCSI commands are sent. There
> is some crude filtering based on file permissions and
> the SCSI command opcode. Other than that, the onus is
> on the person sending the SCSI commands. Mounted file
> systems can be seen in /proc/mounts ** .
> 
> The sg driver is a pass through. The SG_GET_ACCESS_COUNT
> ioctl was a window to a variable which someone else removed
> around 18 months ago. There is little I can do other
> than try to explain ...
> 

Understood and thanks for the info. I know about being having a limited
set of CDB opcodes available for the sd devices however it is much to
limited for me. It just doesn't make sense to me that the "window to the
variable" was closed without offerring a simple alternative.

An application that has been in use for years using a documented and
supported API now eats my root device if I run it???? I think sombody
wasn't thinking too clearly or took an easy way out to a problem they
didn't care to address.

Thanks again
Mark
