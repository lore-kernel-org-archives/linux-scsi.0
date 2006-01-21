From: "Barry K. Nathan" <barryn@pobox.com>
Subject: Re: 2.6.16-rc1-mm2
Date: Sat, 21 Jan 2006 15:57:50 -0800
Message-ID: <986ed62e0601211557s6da09160jce9884ff6b861006@mail.gmail.com>
References: <20060120031555.7b6d65b7.akpm@osdl.org>
	 <200601211139.29019.edt@aei.ca>
	 <986ed62e0601211045p4a61a7c2v91d401af86f50d6@mail.gmail.com>
	 <200601211636.24693.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.201]:22889 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751233AbWAUX5v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jan 2006 18:57:51 -0500
Received: by xproxy.gmail.com with SMTP id s14so485664wxc
        for <linux-scsi@vger.kernel.org>; Sat, 21 Jan 2006 15:57:50 -0800 (PST)
In-Reply-To: <200601211636.24693.edt@aei.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com, jgarzik@pobox.com, linux-scsi@vger.kernel.org

On 1/21/06, Ed Tomlinson <edt@aei.ca> wrote:
[snip]
> smartctl version 5.34 [x86_64-unknown-linux-gnu] Copyright (C) 2002-5 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
[snip]
> Error logging capability:        (0x01) Error logging supported.
>                                         General Purpose Logging supported.
[snip]
>
> SMART Error Log Version: 1
> No Errors Logged
[snip]
> I suspect the newer kernel (or kernels) since when I revert to 15-rc5-mm3 all is well.

That's what it looks like to me, too. Weird...

--
-Barry K. Nathan <barryn@pobox.com>
