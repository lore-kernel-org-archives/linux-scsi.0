From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: best userspace iscsi target lib?
Date: Tue, 11 Nov 2008 15:22:00 +0900
Message-ID: <20081111152229J.fujita.tomonori@lab.ntt.co.jp>
References: <4918B5B2.8050003@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52132 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYKKGWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 01:22:12 -0500
In-Reply-To: <4918B5B2.8050003@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: linux-scsi@vger.kernel.org

On Mon, 10 Nov 2008 17:29:06 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Can someone recommend an open source userspace library that enables one 
> to implement a userspace iSCSI target?

I'm not sure there is an open source userspace library enables you to
easily implement your own userspace iSCSI target but there are some
userspace iSCSI target implementations, which might useful.

Some Linux distributions use:

http://stgt.berlios.de/

OpenSolaris also has one:

http://opensolaris.org/os/project/iscsitgt/

*BSD also have userspace iSCSI target implementations.
