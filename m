From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [Bug 15950] Hang in dc395x driver
Date: Mon, 10 May 2010 20:26:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005102024590.15250@axis700.grange>
References: <bug-15950-11613@https.bugzilla.kernel.org/>
 <201005100416.o4A4G52s018081@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34009 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752363Ab0EJS0X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2010 14:26:23 -0400
In-Reply-To: <201005100416.o4A4G52s018081@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Mon, 10 May 2010, bugzilla-daemon@bugzilla.kernel.org wrote:

> I downloaded the .1 versions of kernel's 2.6.22 through 2.6.26, and
> found that 2.6.25 and above had no changes in the dc395x.c file, but
> that a variety of changes were introduced in 2.6.24 and below.  Since
> the older dc395x.c doesn't drop into my current 2.6.31 kernel, I tried
> recompiling and running 2.6.24 without success.  On Gentoo, the
> current udev doesn't work with that older kernel, so things like
> networking and X fail to run properly and I was unable to test the
> scanner.  Suggestions?

You can use the command-line sane interface scanimage (from the sane-utils 
package).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
