From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] [RFC PATCH 00/32] separate operations from flags in
 the bio/request structs
Date: Wed, 04 Nov 2015 10:53:39 -0600
Message-ID: <563A3813.5010604@cs.wisc.edu>
References: <1446654807-6935-1-git-send-email-mchristi@redhat.com> <563A36FC.6010001@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45597 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030567AbbKDQx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2015 11:53:57 -0500
In-Reply-To: <563A36FC.6010001@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com

On 11/04/2015 10:49 AM, Bart Van Assche wrote:
> Hello Mike,
> 
> If you have to touch submit_bio() and submit_bio_wait(), how about
> requiring the callers of these functions to set the cmd and flags
> arguments in the bio structure and to leave out the cmd and flags
> arguments from the submit_bio() and submit_bio_wait() functions ? A
> (compile tested only) patch that implements this idea is available at
> https://lkml.org/lkml/2014/6/2/173.
> 

Yeah, I can do that.
