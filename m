From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/2 version 4] osdblk: a Linux block device for OSD objects
Date: Wed, 10 Jun 2009 08:52:50 -0400
Message-ID: <4A2FACA2.1070405@garzik.org>
References: <4A155FF6.3060005@panasas.com> <4A15D883.1060104@garzik.org> <4A1B9DA4.2080304@panasas.com> <4A1F10A4.30601@garzik.org> <4A2252D4.3080301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40285 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbZFJMwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 08:52:50 -0400
In-Reply-To: <4A2252D4.3080301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Jens Axboe <jens.axboe@oracle.com>

Boaz Harrosh wrote:
> OK I will release something Quick-And-Dirty end of this week.
> It should do those three tasks osdblk needs:
> Create Resize Delete object@partition@device

That works, thanks!  Honestly, only create and delete are really 
_needed_ IMO.

	Jeff


