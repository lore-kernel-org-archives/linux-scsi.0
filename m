From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Date: Mon, 4 Aug 2008 11:56:33 +0200
Message-ID: <20080804095633.GA20055@kernel.dk>
References: <20080730211842.GF1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753551AbYHDJ4t@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080730211842.GF1758@roadking.ldev.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 30 2008, Mike Miller wrote:
> Patch 6 of 6
> 
> Bug fix. If SCSI tape support is turned off we get an implicit declaration
> of cciss_unregister_scsi error in cciss_remove_one.
> Please consider this for inclusion.

Applied 1-6, thanks.

-- 
Jens Axboe
