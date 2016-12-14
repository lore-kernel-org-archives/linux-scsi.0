From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/22] qla2xxx: Rename qlini_mode parameter
Date: Wed, 14 Dec 2016 13:07:10 -0800
Message-ID: <20161214210710.GD1011@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-16-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481056251-2310-16-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 06, 2016 at 12:30:44PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Qlogic's adapter is able to behave in multiple modes:
> initiator, target, exclusive/either, and dual/both.
> 
> This patch renames the qlini_mode -> qlop_mode and allow
> different setting for each port and exchange resource control.

Removing an old module parameter will break existing setups.  Please
add the new one overriding the old parameter, but don't remove the old
one.
