From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] qla2xxx FC target mode
Date: Sun, 18 Mar 2012 17:22:21 -0700
Message-ID: <1332116541.1612.118.camel@haakon2.linux-iscsi.org>
References: <1327796869.18763.211.camel@haakon2.linux-iscsi.org>
	 <1331941253.10203.280.camel@haakon2.linux-iscsi.org>
	 <1332062541.2855.27.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1332062541.2855.27.camel@dabdike>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, Roland Dreier <roland@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>, Madhu Iyengar <madhu.iyengar@qlogic.com>, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, Arun Easi <arun.easi@qlogic.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-03-18 at 09:22 +0000, James Bottomley wrote:
> On Fri, 2012-03-16 at 16:40 -0700, Nicholas A. Bellinger wrote:
> > James & Co,
> > 
> > Ping..?  Any thoughts on this topic yet..?
> 
> Not really ... we're trying to get the participants to plan the topics
> this year.
> 

Hi James,

I'm asking because the invites for an LSF slot this year to discuss this
topic with the development community has not materialized, and you've
been completely silent to qla2xxx target RFCs + patches that involve the
subject thus far..

The reasons why a face to face discussion at LSF would be useful:

*) It effects existing qla2xxx LLD mainline code
*) It effects future SCSI LLDs + target fabric modules that also want to
   run in mixed mode operation with scsi-core <-> target-core
*) Other subsystem + filesystem maintainers, and key developers have 
   been helping push the code forward for an initial merge
*) Qlogic is supporting us in the mainline effort

So aside from LSF discussion material, I'm really more interested in
determining a plan at how interaction between scsi-core and target-core
subsystems for mixed mode is really going to operate outside of LLD HW
specifics.  Without starting to get some form of feedback from you and
other SCSI core folks, it's difficult to get moving on for-3.5
integration work that I'd like to get started on soon.

So that said, I'll be collecting ACKs for what has been posted last week
in target-pending/for-next-merge that makes qla2xxx by default run with
target mode explicitly disabled, and requires qlini_mode="disabled" in
order to access qla2xxx WWPNs within the TFO->fabric_make_wwn() handler
for tcm_qla2xx.ko code.

Please have a look and let me know if you have objections to the
existing code changes with a for-3.4 merge.

Thanks,

--nab
