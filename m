From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: REQ_SPECIAL from scsi_execute_async()?
Date: Tue, 10 Jul 2007 15:57:40 -0500
Message-ID: <4693F2C4.2090305@cs.wisc.edu>
References: <4693DC36.2010905@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35488 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbXGJU5y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2007 16:57:54 -0400
In-Reply-To: <4693DC36.2010905@greshamstorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jli@greshamstorage.com>
Cc: Linux Scsi <linux-scsi@vger.kernel.org>

Jeremy Linton wrote:
> I was just looking at the REQ_SPECIAL handling and I was curious why 
> REQ_SPECIAL isn't being set for commands being queued by 
> scsi_execute_aysnc()? It is set for scsi_execute() commands.
>

It should not be set from either. What kernel do you see it set in 
scsi_exxecute?
