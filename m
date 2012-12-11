From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Tue, 11 Dec 2012 09:21:46 +0100
Message-ID: <50C6ED1A.7040404@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:44537 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2LKIVu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2012 03:21:50 -0500
In-Reply-To: <20121211000013.GI23107@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/11/12 01:00, scameron@beardog.cce.hp.com wrote:
> I tried using scsi_debug with fake_rw and also the scsi_ram driver
> that was recently posted to get some idea of what the maximum IOPS
> that could be pushed through the SCSI midlayer might be, and the
> numbers were a little disappointing (was getting around 150k iops
> with scsi_debug with reads and writes faked, and around 3x that
> with the block driver actually doing the i/o).

With which request size was that ? I see about 330K IOPS @ 4 KB and 
about 540K IOPS @ 512 bytes with the SRP protocol, a RAM disk at the 
target side, a single SCSI LUN and a single IB cable. These results have 
been obtained on a setup with low-end CPU's. Had you set rq_affinity to 
2 in your tests ?

Bart.
