From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/2] libata-scsi: fix SET FEATURES "filtering" for
 ata_msense_caching()
Date: Tue, 12 Jul 2016 10:53:04 -0400
Message-ID: <20160712145304.GE3190@htj.duckdns.org>
References: <5784f286.c4d0620a.69372.3def@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5784f286.c4d0620a.69372.3def@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2016 at 09:37:02PM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Without this fix, the DRA bit of the caching mode page would not
> be updated when the read look-ahead feature is toggled (e.g. with
> `smartctl --set`), but will only be until, for example, the write
> cache feature is touched.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied to libata/for-4.8.

Thanks.

-- 
tejun
