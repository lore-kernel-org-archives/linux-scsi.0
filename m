From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 09:41:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411B736C.7030103@optonline.net>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz>
 <411A1B72.1010302@optonline.net> <1092231462.2087.3.camel@mulgrave>
 <1092267400.2136.24.camel@gaston> <1092314892.1755.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.5.78]:36485 "EHLO
	mta5.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S268563AbUHLNlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 09:41:12 -0400
In-reply-to: <1092314892.1755.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Pavel Machek <pavel@ucw.cz>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

James Bottomley wrote:

>Why?  We don't do a bus reset on boot, why should we need to do one on
>resume?  For FC, the equivalent, a LIP Reset can be rather nasty on a
>SAN and should be avoided.
>  
>
that can be host specific. aic7xxx does a bus reset on boot, so i 
preserved this on resume.

don't know why they do it, but they do.

>The slight problem is probably going to be knowing that we may need to
>spin up devices (for internal ones) before resuming operation.
>  
>
that's easy for system suspend, but somewhat harder for device suspend
