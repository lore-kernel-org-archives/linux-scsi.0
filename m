From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [LSF/MM TOPIC] [ATTEND] new generation copy offload (ODX)
Date: Fri, 17 Jan 2014 12:20:52 -0500
Message-ID: <52D96674.6060008@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: Hannes Reinecke <hare@suse.de>, linux-fsdevel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke and I would like to attend LSF and present
a talk on the new generation copy offload (a.k.a. ODX).

Most discussions about copy offload at the storage level
are based on T10's 15 year old xcopy(LID1), specifically its
disk->disk copy. This year T10 hopes to standardize a new
generation copy offload whose generic name is xcopy(LID4).
A subset of xcopy(LID4) that does disk->disk copies and
already has vendors with products supporting it, has the
market name of ODX.

ODX is ROD (Representation Of Data) based (as is
xcopy(LID4)) where the copy is split into two steps:
   disk->held  [SCSI POPULATE TOKEN command]
   held->disk  [SCSI WRITE USING TOKEN command]

We would like to discuss how the interfaces (both to the
block layer and the filesystem) should look like for
implementing ROD based copies.
Further we would like to discuss if and how the Linux
target subsystem can be expanded to support ODX in the
future, in addition to the already existing support for
xcopy(LID1).

An example of one of the new ODX/xcopy(LID4) capabilities
can be found in this post:
   http://www.spinics.net/lists/linux-scsi/msg71411.html

We hope to be able to demonstrate some low level Linux
utilities doing ODX copies on a remote array.

Doug Gilbert
