From: Jeff Garzik <jeff@garzik.org>
Subject: Re: best userspace iscsi target lib?
Date: Tue, 11 Nov 2008 09:06:52 -0500
Message-ID: <4919917C.4030109@garzik.org>
References: <4918B5B2.8050003@garzik.org> <20081111152229J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33991 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbYKKOG4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 09:06:56 -0500
In-Reply-To: <20081111152229J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 10 Nov 2008 17:29:06 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Can someone recommend an open source userspace library that enables one 
>> to implement a userspace iSCSI target?
> 
> I'm not sure there is an open source userspace library enables you to
> easily implement your own userspace iSCSI target but there are some
> userspace iSCSI target implementations, which might useful.
> 
> Some Linux distributions use:
> 
> http://stgt.berlios.de/
> 
> OpenSolaris also has one:
> 
> http://opensolaris.org/os/project/iscsitgt/
> 
> *BSD also have userspace iSCSI target implementations.

Thanks much, I will take a look.  I have already found and read the code 
for NetBSD's iSCSI target.

I am mainly interested in 100% userspace solution, because in my case, 
the storage software (distributed goop) is also in userspace.  Something 
that exports through the kernel actually adds overhead, when a 
straight-to-sockets userspace implementation would be more efficient.

	Jeff




