From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] softirq queue is now list_head, eliminate bh_next]
Date: 09 Mar 2003 10:13:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1047226402.10981.9.camel@mulgrave>
References: <3E6A2EBE.5050508@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E6A2EBE.5050508@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Sat, 2003-03-08 at 11:56, Luben Tuikov wrote:
> I just simulated what was in the code before so as to stay
> as close to the ``median'' as possible.
> 
> But ok, I'll delete them and resubmit the patch.

Actually, if you're going to resubmit the patch, could you use per cpu
areas for the queues (rather than __cacheline_aligned)?  It saves space
(on some architectures) and avoids us having to worry about NR_CPUS.

Thanks,

James



