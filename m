From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] fix req->cmd == INT cases
Date: Wed, 20 Jun 2007 14:31:17 +0300
Message-ID: <46791005.70108@panasas.com>
References: <4677FD50.2090803@panasas.com> <20070619171610.GH18863@kernel.dk> <4679072C.2010604@panasas.com> <20070620105912.GQ18863@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:45976 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbXFTLbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2007 07:31:22 -0400
In-Reply-To: <20070620105912.GQ18863@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Jens Axboe wrote:
> On Wed, Jun 20 2007, Boaz Harrosh wrote:
>> Jens Axboe wrote:
>>> If you look at most of the code, it's inside ifdef debug statements or
>>> comments most of them. So I don't think you can base any removal
>>> suggestion on that.
>>>
>>> The patch itself looks fine though, if you send one that isn't mangled
>>> I'll apply it to the 2.6.23 branch.
>>>
>> Sorry new Thunderbird Installation. I forgot it does that.
> 
> The new patch applies cleanly, except on nbd where it fails. It suceeds
> with -l to ignore white space, so perhaps your mail setup isn't 100% up
> to standard yet :-)
> 

Thanks, you are right again, it was set to wrap text at 85 chars and when
so, it will eat spaces at end of lines. Setting wrap to 0 fixes it.
