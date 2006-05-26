From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: PATCH: Bogus disk geometry on large disks
Date: Fri, 26 May 2006 14:57:16 -0500
Message-ID: <200605261957.k4QJvGAe000892@falcon10.austin.ibm.com>
References: <1148660965.20856.35.camel@localhost.localdomain> <20060526175713.GB19587@parisc-linux.org> <1148667738.20856.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:4325 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751404AbWEZT5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 15:57:31 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4QJvSru015995
	for <linux-scsi@vger.kernel.org>; Fri, 26 May 2006 15:57:28 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4QJvSpF065444
	for <linux-scsi@vger.kernel.org>; Fri, 26 May 2006 15:57:28 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4QJvRPE022638
	for <linux-scsi@vger.kernel.org>; Fri, 26 May 2006 15:57:28 -0400
In-reply-to: <20060526182002.GG19587@parisc-linux.org> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org, linux-scsi@vger.kernel.org


On Fri, 26 May 2006 12:20:02 MDT, Matthew Wilcox wrote:
...
>(anyone know how you turn off that fucking UTF8 crap that gcc insists
>on putting into its warning/error messages?  Who thought that was a
>good idea?)

LANG=C works here, and inside emacs.

However, when run from gterm in FC5, looks ok on the screen.

$ gcc -O2 -W -Wall -o test test.c
x.c: In function \u2018main\u2019:
x.c:5: warning: comparison is always true due to limited range of data type
$ echo $LANG
en_US.UTF-8


$ LANG=C gcc -O2 -W -Wall -o test x.c
x.c: In function 'main':
x.c:5: warning: comparison is always true due to limited range of data type
$

So it appears to fix.

++doug

