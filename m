From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Tue, 25 Nov 2014 09:30:19 -0700
Message-ID: <5474AE9B.40104@fb.com>
References: <20141121100210.GC8866@infradead.org> <1416924562-16849-1-git-send-email-tim@seoss.co.uk> <20141125162620.GA31478@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64946 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbaKYQbt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 11:31:49 -0500
In-Reply-To: <20141125162620.GA31478@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Tim Small <tim@seoss.co.uk>
Cc: tim@buttersideup.com, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

On 11/25/2014 09:26 AM, Christoph Hellwig wrote:
> This looks reasonable to me.  Jens, do you want to takes this
> through the block tree?
> 
> Acked-by: Christoph Hellwig <hch@lst.de>

Yeah I can do that, though do we really need to do paride here?

Tim, you also need to work on your changelogs. Please resend (dropping
paride), and add proper subject and commit message. Patches 2-4 have
identical subjects, and no commit message...

-- 
Jens Axboe

