From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 13:56:17 -0700
Message-ID: <CA+55aFxnswLS1ZxYu5B0yS84ugKgcNUzNkyKxV8Yv0Fnx0TJig@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:42230 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaFJU4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 16:56:18 -0400
In-Reply-To: <1402431901.19972.14.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, Jun 10, 2014 at 1:25 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> That would work, or I can simply include a pointer to Stephen's patch in
> the target-pending PULL request after the vhost API changes are merged
> and Linus can apply himself..

Yes. That way I'll include it in the merge, and everything should just work.

          Linus
