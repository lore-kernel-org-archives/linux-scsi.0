From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 6/6] virtio-scsi: Enable DIF/DIX modes in SCSI host
 LLD
Date: Thu, 22 May 2014 13:41:40 -0700
Message-ID: <1400791300.26558.2.camel@haakon3.risingtidesystems.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	 <1400725582-5521-7-git-send-email-nab@daterainc.com>
	 <537DB74B.6010208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36488 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEVUll (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 16:41:41 -0400
In-Reply-To: <537DB74B.6010208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>

On Thu, 2014-05-22 at 10:37 +0200, Paolo Bonzini wrote:
> Il 22/05/2014 04:26, Nicholas A. Bellinger ha scritto:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch updates virtscsi_probe() to setup necessary Scsi_Host
> > level protection resources. (currently hardcoded to 1)
> >
> > It changes virtscsi_add_cmd() to attach outgoing / incoming
> > protection SGLs preceeding the data payload, and is using the
> > new virtio_scsi_cmd_req_pi->d[oi],pi_niv field to signal
> 
> Wrong field name in the commit message...
> 

Fixed

> > to signal to vhost/scsi how many prot_sgs to expect.
> 
> s/prot_sgs to expect/bytes to expect for protection data/
> 

Fixed.

> Apart from this, which can be fixed in the pull request,
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> for getting this in via the target tree.
> 

Thanks Paolo!

--nab

