From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sg: protect against races between mmap() and SG_SET_RESERVED_SIZE
Date: Tue, 22 Aug 2017 22:21:06 -0400
Message-ID: <yq1d17naust.fsf@oracle.com>
References: <20170816054108.119890-1-toddpoynor@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170816054108.119890-1-toddpoynor@google.com> (Todd Poynor's
        message of "Tue, 15 Aug 2017 22:41:08 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Todd Poynor <toddpoynor@google.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org


Todd,

> Take f_mutex around mmap() processing to protect against races with
> the SG_SET_RESERVED_SIZE ioctl.  Ensure the reserve buffer length
> remains consistent during the mapping operation, and set the
> "mmap called" flag to prevent further changes to the reserved buffer
> size as an atomic operation with the mapping.

Applied to 4.14/scsi-queue (with a slight whitespace fix). Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
