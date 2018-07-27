From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 18/26] target/iscsi: Allocate session IDs from an IDA
Date: Fri, 27 Jul 2018 16:05:49 -0500
Message-ID: <5B5B892D.1000305@redhat.com>
References: <20180621212835.5636-1-willy@infradead.org>
 <20180621212835.5636-19-willy@infradead.org> <5B59FB56.9090901@redhat.com>
 <5B5A014D.9060901@redhat.com> <20180727193814.GB3825@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727193814.GB3825@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Kees Cook <keescook@chromium.org>, Varun Prakash <varun@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, Denys Vlasenko <dvlasenk@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 07/27/2018 02:38 PM, Matthew Wilcox wrote:
> On Thu, Jul 26, 2018 at 12:13:49PM -0500, Mike Christie wrote:
>> If we want to fix the bug first, then I made the attached patch and I
>> can submit it.
> 
> How about I take it through my tree to minimise the amount of rebasing
> I'll need to do?  I'm already dependent on the nvdimm tree and I'd rather
> not depend on the scsi tree as well.  I'll queue it up in front of my
> IDA change to maximise its backportability.

Ccing Martin, because he has been handling target patches.

The above plan sounds ok to me.
