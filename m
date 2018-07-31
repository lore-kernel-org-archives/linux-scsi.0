From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 18/26] target/iscsi: Allocate session IDs from an IDA
Date: Tue, 31 Jul 2018 11:15:10 -0700
Message-ID: <20180731181510.GA16794@bombadil.infradead.org>
References: <20180621212835.5636-1-willy@infradead.org>
 <20180621212835.5636-19-willy@infradead.org>
 <5B59FB56.9090901@redhat.com>
 <5B5A014D.9060901@redhat.com>
 <20180727193814.GB3825@bombadil.infradead.org>
 <5B5B892D.1000305@redhat.com>
 <yq1wotcw49i.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1wotcw49i.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <mchristi@redhat.com>, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Kees Cook <keescook@chromium.org>, Varun Prakash <varun@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, Denys Vlasenko <dvlasenk@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 30, 2018 at 10:03:21PM -0400, Martin K. Petersen wrote:
> 
> Mike,
> 
> >> How about I take it through my tree to minimise the amount of rebasing
> >> I'll need to do?  I'm already dependent on the nvdimm tree and I'd rather
> >> not depend on the scsi tree as well.  I'll queue it up in front of my
> >> IDA change to maximise its backportability.
> >
> > Ccing Martin, because he has been handling target patches.
> 
> That's fine with me.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks, Martin.  Mike, can I have your Signed-off-by: on the original patch?
What Fixes: line should this have?  As far as I can tell, the bug is present
all the way back to its introduction, so:

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")

yes?
