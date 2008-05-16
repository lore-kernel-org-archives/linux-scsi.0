From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/7] scsi_dh: Implement generic device table
	handling
Date: Fri, 16 May 2008 11:32:59 -0700
Message-ID: <1210962779.21974.330.camel@chandra-ubuntu>
References: <20080514144310.1EDBC10B5DF@craiglockhart-ipmi.suse.de>
	<1210819551.21974.252.camel@chandra-ubuntu> <482BE368.3070506@suse.de>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <482BE368.3070506@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 2008-05-15 at 09:16 +0200, Hannes Reinecke wrote:
<snip>

> 
> > On the other hand, if we could create a cache of the list of devices
> > (vendor-product-scsi_dh triplet) that has been attached, and walk
> > thru that list first before others during attach, it would help
> > (as we would guess there to be multiple of the same device).
> >  
> Yes, but we can achieve that very same thing by walking the scsi_dh_list.
> I'll fix it up.

interested in seeing that.

<snip>
