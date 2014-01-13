From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device
 attributes
Date: Mon, 13 Jan 2014 10:30:59 -0800
Message-ID: <1389637859.5567.431.camel@haakon3.risingtidesystems.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-10-git-send-email-nab@daterainc.com>
	 <yq161prr1p8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq161prr1p8.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

Hey MKP,

On Fri, 2014-01-10 at 16:01 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:
> 
> nab> This patch adds support for exposing DIF protection device
> nab> attributes via configfs.  This includes:
> 
> nab>    pi_prot_type: Protection Type (0, 1, 3 currently support)
> nab>    pi_prot_version: Protection Version (DIF v1 currently supported)
> 
> What's DIF v2?
> 

This would be the proposed 16-byte protection scheme for SBC4.

> nab>    pi_guard_type: Guard Type (1=DIF CRC, 2=IP CRC)
> 
> The IP checksum is only supported by DIX between OS and initiator, not
> by the target. I guess we could signal to the initiator via a
> vendor-private VPD that IP checksum is supported directly. But now what
> we have hardware-accelerated T10 CRC I don't think it's a big deal.
> 
> (scsi_debug supports IP checksum because it's both initiator and
> target).
> 

In that case, dropping the IP checksum related code now..

--nab
