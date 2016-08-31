From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] bfa: do not dereference port before it is null checked
Date: Wed, 31 Aug 2016 14:05:57 +0200
Message-ID: <20160831120557.p3hcqykbdy3qqaui@c203.arch.suse.de>
References: <20160830163616.11410-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160830163616.11410-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 30, 2016 at 05:36:16PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> port is deferenced before it is null sanity checked, hence
> we potentially have a null pointer dereference bug. Instead,
> initialise trl_enabled from port->fcs->bfa after we are sure
> port is not null.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
