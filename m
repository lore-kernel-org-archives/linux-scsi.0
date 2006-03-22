From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [GIT PATCH] pending SCSI updates for post 2.6.16
Date: Wed, 22 Mar 2006 08:36:47 -0800
Message-ID: <20060322083647.cc0ccdd4.rdunlap@xenotime.net>
References: <1142956795.4377.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:42702 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751360AbWCVQej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 11:34:39 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 08:34:36 -0800
In-Reply-To: <1142956795.4377.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 21 Mar 2006 09:59:55 -0600 James Bottomley wrote:

> This is the set of all the changes I've accumulated since 2.6.16 went
> -rc.  I'm afraid its pretty hefty (another qla firmware update ... but
> at least the built in firmware is now deprecated and we're moving to the
> firmware loader interface)
> 
> The patch is available from
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

Can we get a SCSI_DEBUG link order change (or force it to not
built-in)?

---
~Randy
