From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] libata: Signal that our SATL supports WRITE SAME(16) with UNMAP
Date: Thu, 19 Aug 2010 12:20:34 -0400
Message-ID: <yq1k4nmmv59.fsf@sermon.lab.mkp.net>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	<1282232941-9910-2-git-send-email-martin.petersen@oracle.com>
	<1282234551.8139.25.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282234551.8139.25.camel@mulgrave.site> (James Bottomley's
	message of "Thu, 19 Aug 2010 11:15:51 -0500")
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> Should this be unconditional?  Shouldn't it be conditioned on the
James> current supported trim indicator (which is word 169 being
James> non-zero unless they've changed it yet again)?

I thought about it.  But the VPD page isn't gated on thin provisioning
being enabled.

With the SCSI hat on we won't enable discard unless TPE=1 in READ
CAPACITY(16).  Regardless of whether the device reports TPU=1 or TPWS=1
in the TP VPD.

-- 
Martin K. Petersen	Oracle Linux Engineering
