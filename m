From: Steven Dake <sdake@mvista.com>
Subject: Re: SCSI won't compile with PROC enabled on 2.6.0-test5
Date: Wed, 24 Sep 2003 12:35:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064432106.13033.331.camel@persist.az.mvista.com>
References: <1064429833.13033.316.camel@persist.az.mvista.com>
	 <20030924200954.A23837@infradead.org>
	 <1064431028.13033.324.camel@persist.az.mvista.com>
	 <20030924201908.A24046@infradead.org>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:32325 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S261615AbTIXTfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 15:35:10 -0400
In-Reply-To: <20030924201908.A24046@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

It doesn't even match the error code, but it looks like this:
    char name[10];

On better news, I tried make mrproper, then make menuconfig, configed
the kernel with scsi/proc enabled, and the kernel compiles/boots with
proc enabled.  If I can find out what caused the problem I'll report
back.

Thanks for your help
-steve

On Wed, 2003-09-24 at 12:19, Christoph Hellwig wrote:
> Currently no x86 box here so you're config wouldn't be of any use for
> me even if I asked you to send it.  What's line 80 in your scsi_proc.c?
> 
> 

