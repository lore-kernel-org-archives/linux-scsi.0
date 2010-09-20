From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
Date: Mon, 20 Sep 2010 02:18:10 -0700
Message-ID: <1284974290.13344.466.camel@haakon2.linux-iscsi.org>
References: <1284754930.13344.216.camel@haakon2.linux-iscsi.org>
	 <20100918125729D.fujita.tomonori@lab.ntt.co.jp>
	 <1284841932.13344.339.camel@haakon2.linux-iscsi.org>
	 <4C961644.70209@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C961644.70209@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@suse.de, michaelc@cs.wisc.edu, konrad@darnok.org, jeykholt@cisco.com, hare@suse.de, hch@lst.de, James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, philipp.reisner@linbit.com, martin.petersen@oracle.com, vasu.dev@linux.intel.com, Joel Becker <joel.becker@oracle.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-09-19 at 15:55 +0200, Boaz Harrosh wrote:
> On 09/18/2010 10:32 PM, Nicholas A. Bellinger wrote:
> > On Sat, 2010-09-18 at 13:00 +0900, FUJITA Tomonori wrote:
> > So the RFC cuts have been going into a seperate tree here:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=summary
> > 
> 
> This is the two weeks ago stuff, right. Where is the lio-core-2.6.git/ ?
> 
> > Mike has requested an RFC v2 for him to review TCM Core and TCM_Loop
> > v4.0.0-rc4 changes.  So I will be respinning this tree with the latest
> > changes from lio-core-2.6.git/lio-4.0 and re-posting in the next days.
> > 
> 
> Me to. And a git tree and a git web, as well. I'll postpone any review
> to that time.

Hi Boaz,

So as mentioned earlier, the main upstream branch where all of the
review changes have been moving through is located at
lio-core-2.6.git/lio-4.0:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=shortlog;h=refs/heads/lio-4.0

I will be doing a RFCv2 posting for TCM Core and TCM_Loop v4.0.0-rc4
with the very latest changes this week for Mike, Tomo-san and yourself
to further review.  This series will be in the usual one-file-per-commit
format and will be pushed these into a rfcv2-for-37 branch against
v2.6.36-rc4 in the seperate pristine lio-4.0.git tree mentioned above.

Also just FYI, the workflow I plan to use post-merge for TCM is to
continue to merge all changes in via the lio-core-2.6.git tree, and send
out pull requests for patches destined to mainline via a seperate
pristine tree + branches.

Best,

--nab
