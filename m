From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Tue, 14 Jun 2016 07:55:52 -0700
Message-ID: <20160614145552.GA18075@infradead.org>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <3303bc98-ade7-62f0-71c7-11e7ef42b42d@sandisk.com>
 <20160524160047.Horde.M1bK0S-HUnY41nXa9ZoJ6w1@ltc.linux.ibm.com>
 <12c6229a-3188-b88c-523f-99219ed60c05@sandisk.com>
 <1465885432.5365.214.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465885432.5365.214.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Bryant G Ly <bryantly@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, akpm@linux-foundation.org, kvalo@codeaurora.org, davem@davemloft.net, gregkh@linuxfoundation.org, mchehab@osg.samsung.com, jslaby@suse.com, joe@perches.com, bp@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bgly <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 13, 2016 at 11:23:52PM -0700, Nicholas A. Bellinger wrote:
> AFAICT, the problem with this improvement is that it's not stable
> material, which means that Canonical would have to carry this separately
> beyond linux-4.4.y, in order to support ibmvscsi-tgt.

So who cares?  If they have a business interest in backporting the
driver they'll need to figure out a way.  None of that should matter in
any way whatsover for mainline.
