From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4] libata-scsi: better style in ata_msense_*()
Date: Wed, 20 Jul 2016 11:22:10 -0400
Message-ID: <20160720152210.GB4574@htj.duckdns.org>
References: <5784f28c.c4d0620a.69372.3df2@mx.google.com>
 <578e9008.4500420a.2d828.d131@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <578e9008.4500420a.2d828.d131@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 20, 2016 at 04:39:28AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> `changeable` is the "version" of mode page requested by the user.
> It will be less confusing/misleading if we do not check it
> "together" with the setting bits of the drive.
> 
> Not to mention that we currently have ata_mselect_*() implemented
> in a way that each of them will serve exclusively a particular bit
> on each page. The old style will hence make the condition look even
> more unnecessarily arcane if the ata_msense_*() is reflecting more
> than one bit.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied to libata/for-4.8.

Thanks.

-- 
tejun
