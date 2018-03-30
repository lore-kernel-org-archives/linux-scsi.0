From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/15] mpt3sas: Add sanity checks for scsi tracker before
 accessing it.
Date: Fri, 30 Mar 2018 04:59:17 -0700
Message-ID: <20180330115917.GA30423@infradead.org>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
 <1522402644-3016-4-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522402644-3016-4-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30, 2018 at 03:07:12PM +0530, Chaitra P B wrote:
> Check scsi tracker for NULL before accessing it.
> And in some places there are possibilities for getting valid st
> but still other fields are not set.

Please explain how that could ever happen.  You should never see
a scsi_cmnd without the device pointer.
