From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 07/11] isci: Remove redundant isci_request.ttype field.
Date: Mon, 31 Oct 2011 13:23:39 +0400
Message-ID: <1320053019.8283.26.camel@dabdike>
References: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
	 <20111027220521.4941.68732.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34014 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438Ab1JaJXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2011 05:23:43 -0400
In-Reply-To: <20111027220521.4941.68732.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

On Thu, 2011-10-27 at 15:05 -0700, Dan Williams wrote:
> @@ -3563,7 +3542,7 @@ static struct isci_request
> *isci_io_request_from_tag(struct isci_host *ihost,
>  
>         ireq = isci_request_from_tag(ihost, tag);
>         ireq->ttype_ptr.io_task_ptr = task;
> -       ireq->ttype = io_task;
> +       clear_bit(IREQ_TMF, &ireq->flags);;
>         task->lldd_task = ireq;

Double semicolon.  checkpatch.pl should warn about this.  I fixed it.

James


