From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] qla2xxx: Return the fabric command state for non-task
 management requests
Date: Thu, 23 Jul 2015 02:46:51 -0700
Message-ID: <20150723094651.GA15301@infradead.org>
References: <1437516477-30554-3-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437516477-30554-3-git-send-email-sbaugh@catern.com>
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:QLOGIC QLA2XXX FC-SCSI DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Dilip Kumar Uppugandla <dilip@purestorage.com>, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 21, 2015 at 03:07:55PM -0700, Spencer Baugh wrote:
> From: Dilip Kumar Uppugandla <dilip@purestorage.com>
> 
> Invoking get_cmd_state for qla2xxx always returns 0. Instead change it
> to return the actual fabric state from qla_tgt_cmd. This will help with
> debugging.

I think the ->get_cmd_state callback should go away instead.  Returning
values with zero meaning to the core in a callback doesn't make much
sense.  I'd rather build some real structured debugging infrastructure,
so it would be useful if you could explain the use case for this.
