From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] qla2xxx: Cleanup SRR code.
Date: Mon, 9 Jan 2017 05:13:50 -0800
Message-ID: <20170109131350.GB4438@infradead.org>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482553419-4117-5-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

s/Cleanup/Remove/ ?

Maybe add a little blurb on why we even had this huge pile of dead code
despite not using selective retransmissions, and why you don't plan to
use it any time soon.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
