From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Mon, 09 Jun 2014 11:06:18 +0200
Message-ID: <5395790A.6060704@redhat.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com> <20140608160541.GA21832@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbaFIJGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2014 05:06:37 -0400
In-Reply-To: <20140608160541.GA21832@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>

Il 08/06/2014 18:05, Michael S. Tsirkin ha scritto:
>
> OK, finally went over this, looks good to me:
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>
> However, we really should stop making more changes
> before fixing ANY_LAYOUT in this driver.
>
> virtio 1.0 should be out soon and that makes ANY_LAYOUT
> a required feature.

Agreed.  virtio-blk btw is getting ANY_LAYOUT support in QEMU 2.1, and 
virtio-scsi will follow suit.

Paolo
