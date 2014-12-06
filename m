From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/4] scsi_debug: Unit Attention fixes/enhancements
Date: Sat, 06 Dec 2014 11:38:50 -0500
Message-ID: <5483311A.703@interlog.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53230 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaLFQjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2014 11:39:11 -0500
In-Reply-To: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-12-04 11:49 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> This patch series fixes a couple of problems in the code to generate UAs
> when "virtual_gb" is changed, and adds the generation of a UA when "max_luns"
> is changed.  It also adds the generation of a UA when a WRITE BUFFER
> command is issued.
>
> Patches were generated against jejb for-next branch, with Doug Gilbert's
> earlier patches applied.
>
> Ewan D. Milne (4):
>    scsi_debug: Fixed missing "break;" in SDEBUG_UA_CAPACITY_CHANGED case
>    scsi_debug: Added taking of sdebug_host_list_lock when changing
>      capacity
>    scsi_debug: Add REPORTED LUNS DATA HAS CHANGED Unit Attention
>    scsi_debug: Implement WRITE BUFFER command
>
>   drivers/scsi/scsi_debug.c | 131 ++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 128 insertions(+), 3 deletions(-)

Great work. I have acked and tested each item (i.e. 1 through 4).

I have some other scsi_debug clean ups (e.g. neuter
the host_lock option) but they can wait until the 3.20 series.


BTW I did notice a small regression compared to the existing
"big switch" version of the scsi_debug driver: the VERIFY and the
PREVENT ALLOW MEDIUM REMOVAL commands were accepted (but did
little). Now they are rejected. If that bites anyone, it could
be corrected as a bug fix in 3.19 .

Doug Gilbert




