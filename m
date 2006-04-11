From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] SCSI: fix scsi_kill_request() busy count handling
Date: Tue, 11 Apr 2006 13:44:26 -0400
Message-ID: <443BEAFA.8010104@pobox.com>
References: <20060411082753.GA387@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060411082753.GA387@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, hch@lst.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> scsi_kill_request() completes requests via normal SCSI completion path
> which decrements busy counts; however, requests which get passed to
> scsi_kill_request() aren't holding busy counts and scsi_kill_request()
> don't increment them before invoking completion path resulting in
> incorrect busy counts.  Bump up busy counts before invoking completion
> path.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

ACK.

As with the other two SCSI core patches, we're blocked on linux-scsi people.

Same response as the other two:  if nobody complains, and nobody merges 
into scsi-misc-2.6 in a sane amount of time, I'll push it into libata.

	Jeff



