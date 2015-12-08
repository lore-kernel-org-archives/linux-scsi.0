From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/20] qla2xxx: Change check_stop_free to always return 1
Date: Mon, 7 Dec 2015 18:33:28 -0800
Message-ID: <20151208023328.GA9088@infradead.org>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-10-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449535747-2850-10-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2015 at 07:48:56PM -0500, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
> 
> change tcm_qla2xxx_check_stop_free to always return 1
> to prevent transport_cmd_finish_abort from accidently
> taking extra kref_put.

This looks a bit fishy.  Even if this was the right behavior it's
something all something all drivers returning the value of
target_put_sess_cmd in their check_stop_free would need to do.

Can you explain the issue you're trying to address in a little more
detail?
