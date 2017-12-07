From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: linux-next: build failure after merge of the scsi-mkp tree
Date: Thu, 07 Dec 2017 16:11:03 -0500
Message-ID: <yq1wp1yw8ew.fsf@oracle.com>
References: <20171207145728.57cd9ac4@canb.auug.org.au>
        <1512619169.3298.3.camel@wdc.com>
        <20171207152521.0036b131@canb.auug.org.au>
        <20171207044222.GK7829@linux.vnet.ibm.com>
        <1512667802.2624.20.camel@wdc.com>
        <20171207174038.GQ7829@linux.vnet.ibm.com>
        <20171208073439.1593936d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20171208073439.1593936d@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 8 Dec 2017 07:34:39 +1100")
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>
List-Id: linux-scsi@vger.kernel.org


Stephen,

>> I have to defer to you guys on that one.  Left to myself, I will just
>> push it into the next merge window (as opposed to using my normal
>> process, which at this point would get it into the one following).
>> 
>> So please let me know how you would like to proceed.
>
> Clearly, it needs to go via Martin's tree as otherwise his tree will
> not build in some circumstances ... or if it going to cause problems
> for Paul, then it should be in a separate non-rebasing branch (probably
> of Paul's tree) that is merged into Pauls main branch and Marin's tree.

I'm perfectly OK with taking it through the SCSI tree. Probably the path
of least resistance.

-- 
Martin K. Petersen	Oracle Linux Engineering
