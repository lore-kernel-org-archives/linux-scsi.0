From: Jeremy Linton <jli@greshamstorage.com>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Wed, 8 Nov 2006 10:48:01 -0600
Message-ID: <200611081048.01531.jli@greshamstorage.com>
References: <454FAD72.6040103@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:50948 "EHLO
	austin.greshamstorage.com") by vger.kernel.org with ESMTP
	id S965843AbWKHQsY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Nov 2006 11:48:24 -0500
In-Reply-To: <454FAD72.6040103@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org




On Monday 06 November 2006 15:47, Douglas Gilbert wrote:
> I was asked to put together a proposal in May this
> year for a new SCSI Generic interface structure. This

> Feel free to make suggestions.
	OK...

	A unified multiple device mmap buffer interface for would probably be useful 
as well. This is to get around the problems inherent in the current design 
that keep more than one device from using a mmap/reserve buffer allocated for 
another device. 
	What I would personally like to be able to do with the SG interface is have a 
shared memory region where I can kick off a few dozen tagged commands to a 
device, get notification when they have completed and then send a similar 
command to a second device, all without involving the CPU in any copy 
operations, or too many page management operations.
	In my dream world this would require some kind of tagging of commands as well 
so I don't have to handle a bunch of async completions for commands in a 
group that need to complete as a group.
	
	


