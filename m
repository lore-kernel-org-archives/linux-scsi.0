From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Mon, 02 Mar 2009 14:37:19 -0600
Message-ID: <49AC437F.7020001@cs.wisc.edu>
References: <20090227230927.GA21377@roadking.ldev.net> <20090302153246A.fujita.tomonori@lab.ntt.co.jp> <da824cf30903020919q2d3496e6sb5a253b0acba681a@mail.gmail.com> <49AC237A.7060005@cs.wisc.edu> <20090302183649.GB11787@kernel.dk> <49AC4293.4030902@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36808 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZCBUiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2009 15:38:15 -0500
In-Reply-To: <49AC4293.4030902@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Grant Grundler <grundler@google.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mike.miller@hp.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hare@novell.com, iss_storagedev@hp.com, iss.sbteam@hp.com

Mike Christie wrote:
> iscsi also needs the unique tag and then it needs the 
> blk_map_queue_find_tag functionality too. iscsi needs the lookup and tag 
> for host/transport level commands that do not have a scsi 
> command/request. The tag value has to be unique accross the 
> host/transport

I mean that the tag needs to be unique for scsi/block commands and 
transport commands for each host. So a scsi command and a transport 
command cannot both have tag X.

