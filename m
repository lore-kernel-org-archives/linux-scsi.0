From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: 08 Dec 2003 10:58:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070906283.2263.101.camel@patibmrh9>
References: <1070670440.3056.7.camel@patibmrh9>
	 <3FD43229.7070708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:56739 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265405AbTLHR6M
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2003 12:58:12 -0500
In-Reply-To: <3FD43229.7070708@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > In lk 2.6 I wish sg_scan accepted a list of args e.g.
> > 
> > $ sudo sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]

Kindly offline I'm told `man sg_scan` may have changed lately.  I have
sg installed without root privilege, so I have no man, but my sg_scan.8
is readable.

> > From:sg_scan.8

There I see only the -anwix options defined, in particular the
predefined -a and -n device lists.  I see no support for accepting a
list of devices to try from the command line.  I will write a patch and
reply again.

> Have a look at the sg3_utils-1.06.tgz beta on www.torque.net/sg

1.06 of Mon differs from 1.06 of Fri, aye.  My diff -Nurp between those
yields 1432 lines.  I see CHANGELOG mentions: "accept /dev/hd? ATAPI
devices directly in lk 2.6", I thank you!

> Maybe sg_scan should renamed sam_scan (sadly apart from INQUIRYs
> on st and osst devices).

Lost me help?  I'm guessing this English means an "st device" is a PDT
x01 device aggressively supported by CONFIG_CHR_DEV_ST, and we (lk 2.6)
have history that precludes sg_scan from seeing st devices, and osst is
something like st but distinct.

> the gcc ... warning:

Answered separately in this same thread.  Now I see gcc also complains
of sgm_dd.c.

> BTW The sginfo in that beta decodes mode pages for disks,
> tapes, cd/dvds and enclosures (plus SPI-4, FCP and SAS on
> the transport side).

$ sudo ./sginfo -a /dev/hdc | wc -l
    223
$ sudo ./sginfo -a /dev/hdd | wc -l
    117
$

Fun thank you.

Pat LaVarre


