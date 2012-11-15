From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
	support
Date: Thu, 15 Nov 2012 20:32:35 +0100
Message-ID: <20121115193235.GA5714@lst.de>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org> <1352405238-23267-4-git-send-email-nab@linux-iscsi.org> <20121115110432.GD28956@infradead.org> <1353007786.4447.29.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1353007786.4447.29.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 15, 2012 at 11:29:46AM -0800, Nicholas A. Bellinger wrote:
> Well at least for the latter that is because UNMAP=0 does not have a
> payload.  ;)

UNMAP=0 does have a payload, we just ignore it.  In fact I was told
that targets should check for a completely zeroed sector sized payload
for it if being pedantic.  I can't really find the justification for
that in the standard - the closest thing to it is the stance about
ignoring the unmap bit if the device is fully provisioned.
