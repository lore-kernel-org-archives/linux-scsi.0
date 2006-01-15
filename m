From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sg_io_hdr 32 bit binary compatibility on AMD64
Date: Sun, 15 Jan 2006 17:36:33 +1000
Message-ID: <43C9FB81.9010609@torque.net>
References: <20060113220854.GD12885@paradise.net.nz> <20060115065752.GE12885@paradise.net.nz>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:29849 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751866AbWAOHgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2006 02:36:05 -0500
In-Reply-To: <20060115065752.GE12885@paradise.net.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Volker Kuhlmann <list0570@paradise.net.nz>
Cc: linux-scsi@vger.kernel.org

Volker Kuhlmann wrote:
> Same patch but applied to 2.6.15-git10.
> 
> 
>>Purpose of this patch: establish binary compatibility with 32 bit x86 code on
>>AMD64 64 bit kernels, in the use of struct sg_io_hdr via write()/read() calls.
>>Currently this binary compatibility only exists with ioctl().
>>32bit applications which use or are linked with sanei_scsi.c of the SANE project
>>(sane-project.org) need this patch.

Volker,
I haven't looked at the sane scsi code for some time.
What came to mind was whether it would be easier to convert
sanei_scsi.c t use the SG_IO ioctl provided by the sg
driver.

Doug Gilbert
