From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5775] New: when a scsi device is plugged in
 again, the kernel with dm-multipath paniced
Date: Fri, 20 Jan 2006 00:05:20 -0800
Message-ID: <20060120000520.10812620.akpm@osdl.org>
References: <200512230359.jBN3xMHe008369@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36514 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750705AbWATIGK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 03:06:10 -0500
In-Reply-To: <200512230359.jBN3xMHe008369@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=5775
> 
>             Summary: when a scsi device is plugged in again, the kernel with
>                      dm-multipath paniced

This looks like a qlogic driver crash to me.

