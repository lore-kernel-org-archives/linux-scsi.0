From: Fabian =?iso-8859-1?Q?Gr=FCnbichler?= <f.gruenbichler@proxmox.com>
Subject: Re: [REGRESSION][v4.13.y][v4.14.y] scsi: libsas: allow async aborts
Date: Tue, 5 Dec 2017 09:57:06 +0100
Message-ID: <20171205085614.tyyvu4ultnctbzw4@nora.maurer-it.com>
References: <27d1c9b1-9a80-4982-290b-3916d6e5c80f@canonical.com>
 <100fda00-3da4-1bf1-eaf2-fc0b4fb4fe37@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <100fda00-3da4-1bf1-eaf2-fc0b4fb4fe37@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>, hch@lst.de, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jthumshirn@suse.de, bart.vanassche@wdc.com, bblock@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jth@kernel.org, stable@vger.kernel.org, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 17, 2017 at 03:09:37PM +0100, Hannes Reinecke wrote:
> On 11/16/2017 11:08 PM, Joseph Salisbury wrote:
> > Hi Christoph,
> > 
> > A kernel bug report was opened against Ubuntu [0].  After a kernel
> > bisect, it was found that reverting the following commit resolved this bug:
> > 
> > 909657615d9b ("scsi: libsas: allow async aborts")
> > 
> >      
> > The regression was introduced as of v4.12-rc1, and it still exists in
> > 4.14 mainline.
> > 
> > I was hoping to get your feedback, since you are the patch author.  Do
> > you think gathering any additional data will help diagnose this issue,
> > or would it be best to submit a revert request?
> > 
> I'll be checking what's going on there.
> 
> Cheers,
> 
> Hannes

Any news about this regression? Any traces / data affected users can
provide?

Thanks!
