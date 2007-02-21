From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Please help if u can.
Date: Tue, 20 Feb 2007 22:20:05 -0800
Message-ID: <45DBE495.6050706@us.ibm.com>
References: <45DB9D89.7030804@tlchosting.com> <45DBD6CF.7010309@torque.net>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56383 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbXBUGUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Feb 2007 01:20:10 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1L6K8iE027440
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 01:20:08 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1L6K8xE250588
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 01:20:08 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1L6K7Fg020453
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 01:20:07 -0500
In-Reply-To: <45DBD6CF.7010309@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Scarpa <john@tlchosting.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

Douglas Gilbert wrote:

> It would be reasonable to assume that Luben is the maintainer
> of this code although the MAINTAINERS file has no entry
> for the aic94xx driver.
> 
> This code was effectively removed from Luben's control
> about 18 months ago and has passed through several sets
> of hands since then. None of the people concerned want
> to identify themselves in the source or explain
> what has been done in writing. Why?

Laziness, in my case.  I suppose it would be useful to document the fact
that I've made changes to libsas/aic94xx.  Though the "what has been
done" part ... I was hoping the commit messages would suffice.

> The existing copyright notices should remain but what
> about the massive changes to that driver in 2006?
> Where is the indication of whom John should contact?
>
> Perhaps something like:
>  "For maintenance of this driver contact
>   linux-scsi@vger.kernel.org"

Alexis can answer this part.

> FYI John, Luben maintains his own version of the
> aic94xx and that version holds the sequencer firmware
> in a binary blob within the driver. Due to kernel policy,
> that blob was moved to separate file by someone else. The
> error that you are reporting suggests that the firmware
> file for the aic94xx cannot be found. On my system
> the file that you may be missing looks like this:
> # ls -l /lib/firmware/aic94xx-seq.fw
> -rw-rw-r-- 1 root root 22622 Aug 29 17:36 /lib/firmware/aic94xx-seq.fw

http://kernel.org/pub/linux/kernel/people/jejb/aic94xx-seq.fw

--D
