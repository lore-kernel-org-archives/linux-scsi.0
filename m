From: "Barry K. Nathan" <barryn@pobox.com>
Subject: Re: 2.6.16-rc1-mm2
Date: Sat, 21 Jan 2006 10:45:06 -0800
Message-ID: <986ed62e0601211045p4a61a7c2v91d401af86f50d6@mail.gmail.com>
References: <20060120031555.7b6d65b7.akpm@osdl.org> <43D170CB.8080802@reub.net>
	 <200601211014.44041.edt@aei.ca> <200601211139.29019.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.201]:16767 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932241AbWAUSpH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jan 2006 13:45:07 -0500
Received: by xproxy.gmail.com with SMTP id s14so466651wxc
        for <linux-scsi@vger.kernel.org>; Sat, 21 Jan 2006 10:45:06 -0800 (PST)
In-Reply-To: <200601211139.29019.edt@aei.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com, jgarzik@pobox.com, linux-scsi@vger.kernel.org

On 1/21/06, Ed Tomlinson <edt@aei.ca> wrote:
> grover:/var/log# smartctl -i -d ata /dev/sda
[snip]
> grover:/var/log# smartctl -H -d ata /dev/sda
> smartctl version 5.34 [x86_64-unknown-linux-gnu] Copyright (C) 2002-5 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
>
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
>
> ---
>
> Hope this helps and that I found the correct places to copy the info.

How about:
smartctl -a -d ata /dev/sda
or, if that produces too much output, then at least the following two:
smartctl -A -d ata /dev/sda
smartctl -l error -d ata /dev/sda

That way we might be able to figure out whether the disk
coincidentally started going bad after you updated the kernel.
--
-Barry K. Nathan <barryn@pobox.com>
