From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: Fri, 14 Nov 2003 13:09:43 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB44777.7050104@torque.net>
References: <1068165515.28505.29.camel@patrh9>	 <20031107095145.A3785@beaverton.ibm.com>  <1068228695.3417.34.camel@patrh9>	 <1068229639.3417.46.camel@patrh9>  <1068229873.3417.51.camel@patrh9> <1068594777.6448.7.camel@patrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:40458 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264505AbTKNDKB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 22:10:01 -0500
In-Reply-To: <1068594777.6448.7.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> The SG_IO analogue in BSD may be:
> 
> http://www.google.com/search?q=man+SCIOCCOMMAND
> 
> The corresponding struct appears in such sources as:
> 
> http://cvsup.pt.freebsd.org/cgi-bin/cvsweb/cvsweb.cgi/src/sys/sys/scsiio.h?rev=1.9.4.2&content-type=text/x-cvsweb-markup&cvsroot=NetBSD
> 
> Same as ever, again there we see CDB for length, data for expected
> length returning actual length, sense for expected length returning
> actual length.

Pat,
I don't think the above references are correct. FreeBSD has been
using SCSI's Common Access Method (CAM) for some time. Your can
find one document at www.t10.org (drafts section under the SCSI-2
heading). More appropriate is the withdrawn CAM-3 draft standard (see
www.t10.org/ftp/t10/drafts/cam3/cam3r03.pdf ). That is where you
will find the structure sg_io_hdr was modelled on (struct ccb_scsiio3).

Another way to find SCSI pass-through mechanisms is to look
at Joerg Schilling's libscg. A simpler way may be to look at
smartmontools ( smartmontools.sourceforge.net ) and compare
os_linux.c , os_freebsd.c and os_solaris.c

Doug Gilbert


