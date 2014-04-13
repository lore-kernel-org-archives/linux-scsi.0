From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/6] virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI
 bits
Date: Sat, 12 Apr 2014 21:18:38 -0400
Message-ID: <5349E5EE.2080709@redhat.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com> <1396819929-29687-2-git-send-email-nab@daterainc.com> <20140407095505.GA14432@redhat.com> <53445C9E.2040003@redhat.com> <20140409132239.GE10874@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:43201 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaDMBSw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Apr 2014 21:18:52 -0400
In-Reply-To: <20140409132239.GE10874@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>

Il 09/04/2014 09:22, Michael S. Tsirkin ha scritto:
>> > The interface uses bytes instead of iovecs as the unit, and
>> > vhost-scsi can add the (temporary...) requirement that do_pi_nbytes
>> > and di_pi_nbytes comprise an integer number of iovecs.
>> >
>> > Paolo
> That would be a reasonable intermediate step, but I'm worried there
> are more assumptions lurking in tere.
>
> In particular is it legal for PI to be in the same iov
> entry as data? If not they really need to use a
> separate buf entry.

No, in fact that would mean that do/di_pi_nbytes are not an integer 
number of iovecs.

Paolo
