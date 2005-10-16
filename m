From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Sun, 16 Oct 2005 10:38:59 +1000
Message-ID: <4351A123.9040104@torque.net>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231614.27191.9897.sendpatchset@plap.qlogic.com> <20051015115654.GA24919@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:58061 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751239AbVJPAiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 20:38:18 -0400
In-Reply-To: <20051015115654.GA24919@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Thu, Oct 13, 2005 at 04:16:14PM -0700, Andrew Vasquez wrote:
> 
>>Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> 
> NACK.  My contributions won't be relicensed under such an odd license.
> The real fix is to allow userspace firmware loading for all HBA types
> (as done in one of the later patches) and eventually remove the firmware
> completely.

Andrew,
Another approach is to separate out changes made
by Christoph and Arjan into a separate file (or
files) and leave the GPL on that file.

Doug Gilbert
