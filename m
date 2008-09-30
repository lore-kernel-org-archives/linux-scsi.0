From: "Monty Montgomery" <monty@xiph.org>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Tue, 30 Sep 2008 08:48:55 -0400
Message-ID: <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1213648258.3420.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
	 <1214605634.3394.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
	 <1214841102.3381.5.camel@localhost.localdomain>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
	 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
	 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59218 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYI3Ms6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 08:48:58 -0400
Received: by gxk9 with SMTP id 9so11654309gxk.13
        for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 05:48:56 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

> | 0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
> | (gdb) bt
> | #0  0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
> | #1  0x0ffa7624 in i_read_c_block () from /usr/lib/libcdda_paranoia.so.0
> | #2  0x0ffa9114 in paranoia_read_limited () from /usr/lib/libcdda_paranoia.so.0
> | #3  0x10004da0 in ?? ()
> | #4  0x0fd46704 in ?? () from /lib/libc.so.6
> | #5  0x0fd468c0 in __libc_start_main () from /lib/libc.so.6
> | #6  0x00000000 in ?? ()
>
> due to the `buffer' parameter being NULL.

Oh, good catch.  Platform/drive combination that hadn't been tripped
here.  Fixing in SVN now.

(you're on bigendian or using an old bigendian SCSI drive?)

Monty
