From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] [ATTEND] new generation copy offload (ODX)
Date: Tue, 21 Jan 2014 15:13:33 -0800
Message-ID: <1390346013.5567.802.camel@haakon3.risingtidesystems.com>
References: <52D96674.6060008@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54356 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaAUXL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 18:11:26 -0500
In-Reply-To: <52D96674.6060008@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: lsf-pc@lists.linux-foundation.org, Hannes Reinecke <hare@suse.de>, linux-fsdevel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Fri, 2014-01-17 at 12:20 -0500, Douglas Gilbert wrote:
> Hannes Reinecke and I would like to attend LSF and present
> a talk on the new generation copy offload (a.k.a. ODX).
> 
> Most discussions about copy offload at the storage level
> are based on T10's 15 year old xcopy(LID1), specifically its
> disk->disk copy. This year T10 hopes to standardize a new
> generation copy offload whose generic name is xcopy(LID4).
> A subset of xcopy(LID4) that does disk->disk copies and
> already has vendors with products supporting it, has the
> market name of ODX.
> 
> ODX is ROD (Representation Of Data) based (as is
> xcopy(LID4)) where the copy is split into two steps:
>    disk->held  [SCSI POPULATE TOKEN command]
>    held->disk  [SCSI WRITE USING TOKEN command]
> 
> We would like to discuss how the interfaces (both to the
> block layer and the filesystem) should look like for
> implementing ROD based copies.
> Further we would like to discuss if and how the Linux
> target subsystem can be expanded to support ODX in the
> future, in addition to the already existing support for
> xcopy(LID1).
> 
> An example of one of the new ODX/xcopy(LID4) capabilities
> can be found in this post:
>    http://www.spinics.net/lists/linux-scsi/msg71411.html
> 
> We hope to be able to demonstrate some low level Linux
> utilities doing ODX copies on a remote array.
> 

+1.

I've looked briefly at how an initial implementation might work target
side, and while the SCSI pieces are straight-forward enough to
implement, the bigger issue is how an interface for snapshots within the
backend might work to satisfy the requirements for POPULATE TOKEN..

--nab

