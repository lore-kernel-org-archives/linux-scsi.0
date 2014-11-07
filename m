From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] libata: Whitelist SSDs that are known to properly return zeroes after TRIM
Date: Fri, 07 Nov 2014 10:37:43 -0500
Message-ID: <yq1oasj9g3c.fsf@sermon.lab.mkp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
	<20141107082406.GA8394@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20141107082406.GA8394@infradead.org> (Christoph Hellwig's
	message of "Fri, 7 Nov 2014 00:24:06 -0800")
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> + ata_dev_warn(dev, "Enabling discard_zeroes_data\n");

Christoph> I think this should _info, not _warn.

Fixed.

-- 
Martin K. Petersen	Oracle Linux Engineering
