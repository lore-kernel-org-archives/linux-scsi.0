From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the scsi-mkp tree
Date: Mon, 11 Dec 2017 09:43:51 -0800
Message-ID: <20171211174351.GV7829@linux.vnet.ibm.com>
References: <20171207145728.57cd9ac4@canb.auug.org.au>
 <1512619169.3298.3.camel@wdc.com>
 <20171207152521.0036b131@canb.auug.org.au>
 <20171207044222.GK7829@linux.vnet.ibm.com>
 <1512667802.2624.20.camel@wdc.com>
 <20171207174038.GQ7829@linux.vnet.ibm.com>
 <20171208073439.1593936d@canb.auug.org.au>
 <yq1wp1yw8ew.fsf@oracle.com>
 <yq1k1xyvxrx.fsf@oracle.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1k1xyvxrx.fsf@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Bart Van Assche <Bart.VanAssche@wdc.com>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 07, 2017 at 08:00:50PM -0500, Martin K. Petersen wrote:
> 
> > I'm perfectly OK with taking it through the SCSI tree. Probably the
> > path of least resistance.
> 
> Applied to 4.16/scsi-queue and rebased so it sits before Bart's patch.

Thank you!  I have removed this patch from -rcu.

							Thanx, Paul
