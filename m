From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/8] scsi: merge scsi_finish_command and scsi_io_completion
Date: Wed, 01 Oct 2014 14:55:33 +0200
Message-ID: <542BF9C5.5010704@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:53940 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJAMzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:55:37 -0400
In-Reply-To: <1410107469-896-9-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
>  [ ... ]

Instead of having two functions that each fit on a regular monitor we 
have now one large function that does not fit on most monitors. Is it 
really necessary to merge these two functions ? Has it been considered 
instead of merging these two functions to manually move both functions 
to the same source file such that the compiler can do the inlining ?

Bart.

