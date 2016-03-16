From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] qla2xxx: avoid maybe_uninitialized warning
Date: Wed, 16 Mar 2016 07:24:22 -0700
Message-ID: <1458138262.2421.8.camel@linux.vnet.ibm.com>
References: <1458078051-529344-1-git-send-email-arnd@arndb.de>
	 <1458078554.2375.97.camel@linux.vnet.ibm.com> <2808565.5VeioJTJAb@wuerfel>
	 <D30EB4C2.DE792%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D30EB4C2.DE792%himanshu.madhani@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Quinn Tran <quinn.tran@qlogic.com>, Alexei Potashnik <alexei@purestorage.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Swapnil Nagle <swapnil.nagle@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-03-16 at 14:05 +0000, Himanshu Madhani wrote:
> 
> On 3/16/16, 5:59 AM, "Arnd Bergmann" <arnd@arndb.de> wrote:
> 
> > On Tuesday 15 March 2016 14:49:14 James Bottomley wrote:
> > > On Tue, 2016-03-15 at 22:40 +0100, Arnd Bergmann wrote:
> > > > 
> > > > This slightly rearranges the code to move the second if() block
> > > > into the first one, to avoid the warning while retaining the
> > > > behavior of the code.
> > > 
> > > I thought our usual policy was to ask someone to fix the compiler 
> > > when it emitted a spurious warning.
> > 
> > No, the rule is that we shouldn't blindly add initializations to
> > the variables when the compiler should have figured it out.
> > 
> > In this case, I wouldn't expect the compiler to ever see through
> > the unlikely() macro, and I'm not adding a potentially 
> > counterproductive initialization, so I see no reason not to apply
> > the patch.

OK, as long as there's a good reason why the compiler can never be
fixed to sort out this case.

> I would like to keep unlikely() macro in the code. This patch looks
> good.
> 
> Acked-By: Himanshu Madhani <himanshu.madhani@qlogic.com>

Well, OK that's good enough for me.

James
