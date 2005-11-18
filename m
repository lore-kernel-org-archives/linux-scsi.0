From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/3] cciss: bug fix for hpacucli
Date: Fri, 18 Nov 2005 21:49:47 +0100
Message-ID: <20051118204946.GB25454@suse.de>
References: <20051118163357.GA10928@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161200AbVKRUwF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051118163357.GA10928@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hpa@zytor.com, sitniko@infonet.ee
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 18 2005, mikem wrote:
> Patch 1 of 3
> 
> This patch fixes a bug that breaks hpacucli, a command line interface
> for the HP Array Config Utility. Without this fix the utility will
> not detect any controllers in the system. I thought I had already fixed
> this, but I guess not.
> 
> Thanks to all who reported the issue. Please consider this this inclusion.

Lovely, hope this makes it able to configure my drives on the tiger now
:).

Applied.

-- 
Jens Axboe
