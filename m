From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] target: Fix transport_cmd_finish_abort queue removal
 bug
Date: Sat, 8 Oct 2011 21:33:26 -0400
Message-ID: <20111009013326.GC32104@infradead.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
 <1317358511-10664-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1317358511-10664-4-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

The fix looks reasonable, but shouldn't the reordering also be applied
to transport_cmd_finish_abort_tmr?
