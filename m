From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length
 in case pi exists on the wire
Date: Tue, 10 Jun 2014 10:12:05 +0200
Message-ID: <5396BDD5.4080206@redhat.com>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>	 <1402223228-23768-4-git-send-email-sagig@mellanox.com> <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: michaelc@cs.wisc.edu, martin.petersen@oracle.com, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Il 10/06/2014 10:04, Nicholas A. Bellinger ha scritto:
>
> That said, there is one other small qla2xxx change to enable per-session
> PI that is currently missing in Quinn's patch in scsi/for-next code.
>
> Sooo, I'll go ahead and include Sagi's patches with the vhost-scsi
> change below if there are no objections from MKP and/or driver
> maintainers, and post an -rc2 series after the merge window closes to
> address the two remaining qla2xxx specific items.

Indeed the patch looks like a tcm bugfix.  There is no reason to modify 
the LLD.

Paolo
