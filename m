From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: [Bugme-new] [Bug 4166] New: BUG: using smp_processor_id()
 in preemptible [00000001] code: nfsd/2783
Date: Mon, 7 Feb 2005 16:00:56 -0800
Message-ID: <20050207160056.0c50305e.akpm@osdl.org>
References: <20050204134809.2d341367.akpm@osdl.org>
	<20050207234119.GA13400@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fw.osdl.org ([65.172.181.6]:49290 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261322AbVBGX4B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2005 18:56:01 -0500
In-Reply-To: <20050207234119.GA13400@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
>
> -	if (smp_processor_id() == ha->last_irq_cpu || was_empty)
> +	if (_smp_processor_id() == ha->last_irq_cpu || was_empty)

Am I correct in assuming that if we are preempted, and if
_smp_processor_id() returns the wrong number, the driver will continue to
function correctly?  And that we simply missed a little optimisation
opportunity?
