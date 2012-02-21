From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 09/11] iscsi_transport: Added Ping support
Date: Wed, 22 Feb 2012 00:39:44 +0200
Message-ID: <CAJZOPZKo5O8GMO9dz09UAvX8gHd5bT-Y2MdRkckh9dv2Q=m1jA@mail.gmail.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
	<1329138050-1042-10-git-send-email-vikas.chaudhary@qlogic.com>
	<CAJZOPZLdXtdLyTstWLu8A1Q454LD4k-0+HoDdqEHwFzbs+Ro6g@mail.gmail.com>
	<4F441BC5.4000301@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51658 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618Ab2BUWjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 17:39:46 -0500
Received: by lagu2 with SMTP id u2so8221001lag.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2012 14:39:44 -0800 (PST)
In-Reply-To: <4F441BC5.4000301@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: vikas.chaudhary@qlogic.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com

On Wed, Feb 22, 2012 at 12:33 AM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> This is network based. ICMP pings. The stuff we have today is iscsi
> based pings. So you can do some basic network diag type of stuff.

So what's wrong with plain ICMP pings... or is this is for
cards/drivers which don't expose plain network interface to the
kernel?

Or.
