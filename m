From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] T10-PI RDMA offload
Date: Mon, 20 Jan 2014 13:51:52 +0100
Message-ID: <52DD1BE8.8080500@acm.org>
References: <52D7F6DC.10502@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yahoo.smtp.stone-is.be ([5.134.1.31]:33273 "EHLO
	yahoo.smtp.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATM6U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2014 07:58:20 -0500
In-Reply-To: <52D7F6DC.10502@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, lsf-pc@lists.linux-foundation.org
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Oren Duer <oren@mellanox.com>

On 01/16/14 16:12, Sagi Grimberg wrote:
> Hey SCSI (and LSF) folks,
> 
> I'd like to propose the following topic for upcoming LSF-MM:
> 
> T10-PI standard is becoming more and more appealing for storage and
> cloud solutions.
> Since error-detection coding comes with its cost of CPU computation
> overhead,
> state-of-the-art ASICs offer the ability to offload T10-PI operations
> (DIF/DIX), examples
> are SAS & FC controllers. Recently, the support for T10-PI offload over
> RDMA transactions
> was introduced in the Mellanox Connect-IB HCA.
> 
> The first building block, RDMA verbs API supporting T10-PI offload was
> submitted over
> Linux-rdma (see http://marc.info/?l=linux-rdma&m=138719320307936&w=2).
> Moreover,
> we have seen first seeds of T10-PI support in Linux SCSI target entering
> v3.14 (see
> http://lwn.net/Articles/579708/) and RDMA offload implementation in iSER
> transport
> (see http://www.spinics.net/lists/linux-scsi/msg71128.html). There is
> still some ground to
> fill to get protection information support to a full solution over all
> backend devices.
> 
> We would like to use LSF-MM platform to to push forward T10-PI support
> end-to-end which
> requires Linux SCSI Target core level support along with transport level
> support in iSER and SRP
> (and also FCoE in the future) and over to the Initiator side transports.
> 
> Discussion topics:
> - Introduce T10-PI offload RDMA verbs and how are used in storage
> applications.
> - Discuss effects of DIX1.1 (currently a draft) in Target implementation
> (core level -> transport level -> HW level).
> - Discuss T10-PI Type 4 (16-byte DIF) status and possible implications
> on Target & Initiator implementation down to HW level.
> - Discuss Current Limitations that T10-PI RDMA offload poses on iSCSI
> protocol (ImmediateData, UnsolDataOut) and if/how
>   they can be solved.
> - What-ever else comes to mind...

+1 for this topic.

As a contributor to the SRP protocol implementation I'm interested in
this discussion. Having an API for T10-PI offload in the RDMA core is a
prerequisite before T10-PI support can be added in the SRP initiator and
target drivers.

Bart.

