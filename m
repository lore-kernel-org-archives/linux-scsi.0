From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] libiscsi: avoid unnecessary multiple NULL assignments
Date: Wed, 10 Apr 2013 11:28:04 -0500
Message-ID: <51659314.1050404@cs.wisc.edu>
References: <1365611079-15011-1-git-send-email-michaelc@cs.wisc.edu> <1365611079-15011-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37391 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937001Ab3DJQ2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 12:28:12 -0400
In-Reply-To: <1365611079-15011-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>

On 04/10/2013 11:24 AM, michaelc@cs.wisc.edu wrote:
> From: Masatake YAMATO <yamato@redhat.com>
> 
> In iscsi_free_task, NULL is assigned to task->sc twice: before and
> after kfifo_in invocatoin. Allocating and freeing iscsi_task are guarded
> with session->lock, so multiple NULL assignments cause no trouble. But
> people reading the source code may be confused.
> 
> The second NULL assignment comes from commit:
> 
>     3e5c28ad0391389959ccae81c938c7533efb3490
> 
> It seems that the line after kfifo_in invocation was introduced
> accidentally.
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Sorry about the incorrect signed of chain James. When I sent/made the
patches I added both a reviewed-by and signed-off to this one by accident.

Masatake made the patch. I am just resending to the list.
