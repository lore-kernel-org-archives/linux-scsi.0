From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 1/2] libata-scsi: do not respond with "invalid
 field" for FORMAT UNIT
Date: Wed, 6 Jul 2016 13:32:34 -0400
Message-ID: <20160706173234.GA4065@mtj.duckdns.org>
References: <577d3c35.949b620a.2f8b5.ffffb1c4@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <577d3c35.949b620a.2f8b5.ffffb1c4@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 07, 2016 at 01:13:08AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> It does not make sense and is confusing to respond with "Invalid
> field in CDB" while we have no support at all implemented for
> FORMAT UNIT. It is decent to let it go to the default, which
> will respond with "Invalid command operation code" instead.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied to libata/for-4.8.

Thanks.

-- 
tejun
