From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 18/26] target/iscsi: Allocate session IDs from an IDA
Date: Mon, 30 Jul 2018 22:03:21 -0400
Message-ID: <yq1wotcw49i.fsf@oracle.com>
References: <20180621212835.5636-1-willy@infradead.org>
        <20180621212835.5636-19-willy@infradead.org>
        <5B59FB56.9090901@redhat.com> <5B5A014D.9060901@redhat.com>
        <20180727193814.GB3825@bombadil.infradead.org>
        <5B5B892D.1000305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B5B892D.1000305@redhat.com> (Mike Christie's message of "Fri,
        27 Jul 2018 16:05:49 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Kees Cook <keescook@chromium.org>, Varun Prakash <varun@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, Denys Vlasenko <dvlasenk@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


Mike,

>> How about I take it through my tree to minimise the amount of rebasing
>> I'll need to do?  I'm already dependent on the nvdimm tree and I'd rather
>> not depend on the scsi tree as well.  I'll queue it up in front of my
>> IDA change to maximise its backportability.
>
> Ccing Martin, because he has been handling target patches.

That's fine with me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
