From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Mon, 17 Oct 2005 21:22:48 +1000
Message-ID: <43538988.3000204@torque.net>
References: <20051015013824.GA25248@linux-mips.org> <20051017104312.GB22710@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:11479 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751181AbVJQLVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 07:21:49 -0400
In-Reply-To: <20051017104312.GB22710@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: Christoph Hellwig <hch@infradead.org>, Ralf Baechle <ralf@linux-mips.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

Christoph Hellwig wrote:
> On Sat, Oct 15, 2005 at 02:38:24AM +0100, Ralf Baechle wrote:
> 
>>FYI and reviewing pleassure.
> 
> 
> NACK, no more new procfs support for scsi driver.

James Bottomley,
Is there any such policy?

Christoph Hellwig previously has used this purported policy
to reject scsi procfs bug fixes:
"[PATCH] scsi: /proc/scsi/scsi patch for large number of devices"
As for alternate tools to 'cat /proc/scsi/scsi', I
am not aware of many distributions using lsscsi (debian
and gentoo do), perhaps there are other tools. I
suspect a lot of folks are still using 'cat /proc/scsi/scsi'.

Does Christoph Hellwig have the right to NACK/veto
etc work that is not his when you are the SCSI maintainer?

Douglas Gilbert

