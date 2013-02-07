From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 07 Feb 2013 13:29:26 +0100
Message-ID: <51139E26.1080406@acm.org>
References: <20130206195122.GA30652@sgi.com> <20130206202444.GA4771@blackbox.djwong.org> <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com> <20130207094012.GA28047@localhost> <20130207100139.GB4773@blackbox.djwong.org> <51138FA0.1080507@suse.de> <51139940.3000902@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <51139940.3000902@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Hannes Reinecke <hare@suse.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On 02/07/13 13:08, Boaz Harrosh wrote:
> (My addition is for support of sg_lists to bsg, in a way that makes Tomo happy
>   I know that qemu was wanting this for a while as well as the multitude of
>   user-mode servers)

Do you think it would help / make sense if sg_alloc_table() would be 
modified such that it allocates the entire scatterlist table via one 
vmalloc() call instead of chaining several page-sized scatterlist tables 
? Note: such a change is not possible without modifying 
scsi_alloc_sgtable().

Bart.
