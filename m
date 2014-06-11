From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Wed, 11 Jun 2014 11:04:47 +0300
Message-ID: <20140611080447.GB7248@redhat.com>
References: <20140610094254.GC7423@redhat.com>
 <20140610215217.495d5476@canb.auug.org.au>
 <20140610130208.GA27702@redhat.com>
 <1402421957.23024.15.camel@haakon3.risingtidesystems.com>
 <20140610184531.GA27760@redhat.com>
 <1402430265.19972.9.camel@haakon3.risingtidesystems.com>
 <1402430984.2185.116.camel@dabdike.int.hansenpartnership.com>
 <1402431901.19972.14.camel@haakon3.risingtidesystems.com>
 <CA+55aFxnswLS1ZxYu5B0yS84ugKgcNUzNkyKxV8Yv0Fnx0TJig@mail.gmail.com>
 <1402435228.19972.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbaFKIEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 04:04:41 -0400
Content-Disposition: inline
In-Reply-To: <1402435228.19972.17.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, Jun 10, 2014 at 02:20:28PM -0700, Nicholas A. Bellinger wrote:
> On Tue, 2014-06-10 at 13:56 -0700, Linus Torvalds wrote:
> > On Tue, Jun 10, 2014 at 1:25 PM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:
> > >
> > > That would work, or I can simply include a pointer to Stephen's patch in
> > > the target-pending PULL request after the vhost API changes are merged
> > > and Linus can apply himself..
> > 
> > Yes. That way I'll include it in the merge, and everything should just work.
> > 
> 
> <nod>, sounds good.
> 
> MST, please drop the target related patches from your tree, and go ahead
> and send your PULL request now.
> 
> --nab

ack.
Doing it right now.

