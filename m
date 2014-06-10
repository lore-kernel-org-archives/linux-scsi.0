From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 14:20:28 -0700
Message-ID: <1402435228.19972.17.camel@haakon3.risingtidesystems.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	 <20140609133026.GA6239@redhat.com>
	 <1402383912.5774.13.camel@haakon3.risingtidesystems.com>
	 <20140610094254.GC7423@redhat.com>
	 <20140610215217.495d5476@canb.auug.org.au>
	 <20140610130208.GA27702@redhat.com>
	 <1402421957.23024.15.camel@haakon3.risingtidesystems.com>
	 <20140610184531.GA27760@redhat.com>
	 <1402430265.19972.9.camel@haakon3.risingtidesystems.com>
	 <1402430984.2185.116.camel@dabdike.int.hansenpartnership.com>
	 <1402431901.19972.14.camel@haakon3.risingtidesystems.com>
	 <CA+55aFxnswLS1ZxYu5B0yS84ugKgcNUzNkyKxV8Yv0Fnx0TJig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxnswLS1ZxYu5B0yS84ugKgcNUzNkyKxV8Yv0Fnx0TJig@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-06-10 at 13:56 -0700, Linus Torvalds wrote:
> On Tue, Jun 10, 2014 at 1:25 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > That would work, or I can simply include a pointer to Stephen's patch in
> > the target-pending PULL request after the vhost API changes are merged
> > and Linus can apply himself..
> 
> Yes. That way I'll include it in the merge, and everything should just work.
> 

<nod>, sounds good.

MST, please drop the target related patches from your tree, and go ahead
and send your PULL request now.

--nab
