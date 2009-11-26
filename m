From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Thin provisioning fixes (take 3)
Date: Thu, 26 Nov 2009 12:27:20 -0500
Message-ID: <yq14oohb3if.fsf@sermon.lab.mkp.net>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
	<1259255380.7584.64.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1259255380.7584.64.camel@mulgrave.site> (James Bottomley's
	message of "Thu, 26 Nov 2009 11:09:40 -0600")
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> So you forgot to specify ordering.  I think the right ordering is
James> that actually, there isn't any.  Jens can take 1, I can take 2,3
James> and Jeff can take 4,5 without running any postmerge trees ... is
James> that correct?

The only dependency is that the sd patch (#2) requires "block: Expose
discard granularity" (86b37281411cf1e9bc0a6b5406c45edb7bd9ea5d) in Jens'
for-2.6.33 tree.

So we will need either a rebase or a postmerge tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
