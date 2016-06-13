From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Add support for SCT Write Same
Date: Mon, 13 Jun 2016 01:02:43 -0700
Message-ID: <20160613080243.GB26544@infradead.org>
References: <1465453967-11085-1-git-send-email-shaun@tancheff.com>
 <1465453967-11085-2-git-send-email-shaun@tancheff.com>
 <20160609092212.GA7459@infradead.org>
 <CAJVOszAO7YxznaUNs1+HaN=aRaA3yPiQDYHSQw+To6BKMEL++A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJVOszAO7YxznaUNs1+HaN=aRaA3yPiQDYHSQw+To6BKMEL++A@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 09, 2016 at 10:24:40PM -0500, Shaun Tancheff wrote:
> >  - The plain page_address above looks harmful, how do we know that
> >    the page is mapped into kernel memory?  This might actually be broken
> >    already, though.
> 
> I think it just happens to work because it's always used with a recently
> allocated page. Fixing it to include the (possible) offset is just a good thing.

I haven't spent much time with libata recently, but what prevents an
arbitrary user page ending up here through SG_IO?
