From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the scsi-mkp tree
Date: Fri, 8 Dec 2017 07:34:39 +1100
Message-ID: <20171208073439.1593936d@canb.auug.org.au>
References: <20171207145728.57cd9ac4@canb.auug.org.au>
        <1512619169.3298.3.camel@wdc.com>
        <20171207152521.0036b131@canb.auug.org.au>
        <20171207044222.GK7829@linux.vnet.ibm.com>
        <1512667802.2624.20.camel@wdc.com>
        <20171207174038.GQ7829@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171207174038.GQ7829@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

On Thu, 7 Dec 2017 09:40:38 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>
> On Thu, Dec 07, 2017 at 05:30:03PM +0000, Bart Van Assche wrote:
> > However, what's not clear to me is through which tree this patch should be
> > sent to Linus? Should the above patch be sent as a v4.15-rc fix or should
> > Martin perhaps queue it in his tree for v4.16-rc1?  
> 
> I have to defer to you guys on that one.  Left to myself, I will just
> push it into the next merge window (as opposed to using my normal process,
> which at this point would get it into the one following).
> 
> So please let me know how you would like to proceed.

Clearly, it needs to go via Martin's tree as otherwise his tree will
not build in some circumstances ... or if it going to cause problems
for Paul, then it should be in a separate non-rebasing branch (probably
of Paul's tree) that is merged into Pauls main branch and Marin's tree.
-- 
Cheers,
Stephen Rothwell
