From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH] fc: ensure scan_work isn't active when
 freeing fc_rport
Date: Tue, 10 Jun 2014 11:49:31 -0400
Message-ID: <20140610154931.GE6275@hmsreliant.think-freely.org>
References: <1401461974-7879-1-git-send-email-nhorman@tuxdriver.com>
 <1401751370.5752.5.camel@vi-devel>
 <20140606205409.GD2543@hmsreliant.think-freely.org>
 <1402337383.5752.153.camel@vi-devel>
 <20140609191637.GA3535@hmsreliant.think-freely.org>
 <20140610113841.GC26195@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140610113841.GC26195-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 10, 2014 at 04:38:41AM -0700, Christoph Hellwig wrote:
> On Mon, Jun 09, 2014 at 03:16:37PM -0400, Neil Horman wrote:
> > > Given fcoe is quite mature now and its patches volume is very low, so
> > > getting its kernel patches directly to scsi subsystem should work fine
> > > and should be okay with James or Christophs to pull into scsi subsystem
> > > directly once I've my non-author signoff ACK there as described in this
> > > announcement at http://marc.info/?l=linux-scsi&m=140050839729415&w=2 
> > > 
> > > If no alternate suggestion or objection to this then I'll formally
> > > announce this on fcoe mailing list.
> > > 
> > > However for any huges patches series bomb or RFCs, I'll request fcoe
> > > developers to send patches against scsi tree at fcoe devel list first
> > > and then if needed I can roll them up.
> > > 
> > > Thanks,
> > > Vasu
> > > 
> > Copy that Vasu, Christoph, is that ok with you?
> 
> That's fine with me.  It would help greatly if you could make sure
> all the paches get a review or two very quickly so I can just pick them
> up immediately after reviewing them.
> 
> 
Roger that, Vasu has already acked this.  I thought there was a second, but I'm
not sure, my mailbox is a bit messed up at the moment.

Sorry for not cc-ing you on this sooner, I thought it was going to go through
the FCoE tree initially

Best
Neil
