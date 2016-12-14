From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/22] qla2xxx: Refactor T10-DIF PI support
Date: Wed, 14 Dec 2016 13:03:42 -0800
Message-ID: <20161214210342.GA1011@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-10-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481056251-2310-10-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 06, 2016 at 12:30:38PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> qla2xxx currently access T10-DIF protection opcode and type
> field in se_cmd struct. Add translation code so qla2xxx driver
> would not acces private TCM data structure.

And what's the point of doing that?

>  11 files changed, 661 insertions(+), 242 deletions(-)

And independent of the above a "cleanup" that adds over 400 lines of
code is simply not acceptable.
