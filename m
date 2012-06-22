From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_dh_alua: Re-enable STPG for unavailable ports
Date: Fri, 22 Jun 2012 18:50:20 +0000
Message-ID: <4FE4BE6C.1080608@acm.org>
References: <4FE431A2.2050500@acm.org> <77471C95FAFD844C8CA02DD4F4C5FE2B07E504FD@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:39984 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab2FVSuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 14:50:24 -0400
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B07E504FD@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 06/22/12 17:52, Moger, Babu wrote:

> One concern, the spec also says..
> ==============================
> The unavailable target port asymmetric access state is
> intended for situations when the target port accessibility to a logical unit may be severely restricted due to SCSI
> target device limitations (e.g., hardware errors). Therefore it may not be possible to transition from this state to
> either the active/optimized, active/non-optimized or standby states.
> =====================================================
> 
> What happens if we cannot transition to active/optimized, active/non-optimized or standby states.  
> Are we going to loop forever?  From kernel side it looks ok.  We are going mark the path as failed.  
> It depends on what the path checker from multipath is going to do.  Do you have any idea about it?


Good question. I'm not a multipath expert, but as far as I understand
the multipath user space software if activating a path fails after some
delay multipathd tries again to find a usable I/O path.

Bart.
