From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] libata-scsi: fix read-only bits checking in
 ata_mselect_*()
Date: Wed, 20 Jul 2016 11:25:05 -0400
Message-ID: <20160720152505.GD4574@htj.duckdns.org>
References: <578eaead.0198620a.7cf53.28c1@mx.google.com>
 <578eb0d1.e9b9420a.8694b.fc4c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <578eb0d1.e9b9420a.8694b.fc4c@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: hare@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 20, 2016 at 06:59:23AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Commit 7780081c1f04 ("libata-scsi: Set information sense field for
> invalid parameter") changed how ata_mselect_*() make sure read-only
> bits are not modified. The new implementation introduced a bug that
> the read-only bits in the byte that has a changeable bit will not
> be checked.
> 
> Added the necessary check, with comments explaining the heuristic.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied to libata/for-4.8.

This thread was confusing to look at.  Please use the "n/N" sequence
tagging for the patches (the -n option of git-format-patch).

Thanks.

-- 
tejun
