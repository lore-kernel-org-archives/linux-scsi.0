From: John Hasler <john@dhh.gt.org>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Thu, 25 Mar 2004 19:30:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8765csbdjv.fsf@toncho.dhh.gt.org>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de>
	<20040325082949.GA3376@gondor.apana.org.au>
	<20040325220803.GZ16746@fs.tum.de> <40635DD9.8090809@pobox.com>
	<1080260235.3643.103.camel@imladris.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa-3.airstreamcomm.net ([64.33.192.163]:56587 "EHLO
	sa-3.airstreamcomm.net") by vger.kernel.org with ESMTP
	id S263834AbUCZBYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2004 20:24:32 -0500
In-Reply-To: <1080260235.3643.103.camel@imladris.demon.co.uk> (David
 Woodhouse's message of "Fri, 26 Mar 2004 00:17:15 +0000")
List-Id: linux-scsi@vger.kernel.org
To: 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

David Woodhouse writes:
> The firmware blob in question can be reasonably considered to be an
> independent and separate work in itself. The GPL doesn't apply to it when
> it is distributed as a SEPARATE work. But when you distribute it as part
> of a whole which is a work based on other parts of the kernel, by
> including it in the kernel source...

So don't.  Put it in a seperate file and load it at boot time.
-- 
John Hasler               You may treat this work as if it 
john@dhh.gt.org           were in the public domain.
Dancing Horse Hill        I waive all rights.
Elmwood, Wisconsin
