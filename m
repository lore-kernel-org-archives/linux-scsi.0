From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Thu, 12 Jan 2012 13:59:45 -0600
Message-ID: <4F0F3BB1.7090902@cs.wisc.edu>
References: <1325618414-26992-1-git-send-email-revers@redhat.com> <4F0EAB53.7020404@suse.de> <4F0F124D.3000708@redhat.com> <4F0F4F43.2010902@suse.de> <4F0F3A73.9060602@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49493 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2ALT75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 14:59:57 -0500
In-Reply-To: <4F0F3A73.9060602@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Rob Evers <revers@redhat.com>, linux-scsi@vger.kernel.org

On 01/12/2012 01:54 PM, Mike Christie wrote:
> alua_check_sense will return ADD_TO_MLQUEUE_DELAY then scsi_check_sense
> will pass that up and scsi_decide_disposition will return that right
> away.

I mean it is one of those weird ones where we do not do the goto
maybe_retry in scsi_decide_disposition, so we do not see the fast fail
bit set. This happens for ADD_TO_MLQUEUE_DELAY and ADD_TO_MLQUEUE.

