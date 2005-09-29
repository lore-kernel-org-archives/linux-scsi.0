From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: SATA suspend/resume (was Re: [PATCH] updated version of Jens'
 SATA suspend-to-ram patch)
Date: Thu, 29 Sep 2005 14:48:06 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0509291446430.1424@shark.he.net>
References: <20050923163334.GA13567@triplehelix.org> <433B79D8.9080305@pobox.com>
 <Pine.LNX.4.58.0509291309050.1424@shark.he.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:61403 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030261AbVI2VsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 17:48:06 -0400
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2005 14:48:06 -0700
In-Reply-To: <Pine.LNX.4.58.0509291309050.1424@shark.he.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, Joshua Kwan <joshk@triplehelix.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de, torvalds@osdl.org

On Thu, 29 Sep 2005, Randy.Dunlap wrote:

> Here's Nathan Bryant's patch (from the lwn.ne article) updated
> to 2.6.14-rc2-git7 + changes that Christoph suggested (except
> that 'scsi_device_resume' name was already used, so I changed it
> to 'scsi_device_wakeup' instead).
>
> I'll get back to Jeff's suggestion(s) and the sysfs flag next,
> but others can use this as a basis if wanted.
>
> (also available from
> http://www.xenotime.net/linux/scsi/scsi-suspend-resume.patch
> )

The inline version of this patch is whitespace-damaged  :(
(thanx to pine).

It's ok for review, but please download the one above
for applying or patching.

-- 
~Randy
