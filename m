From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libfc: Fix variable name in fc_set_wwpn
Date: Fri, 13 Jan 2017 09:09:12 +0100
Message-ID: <20170113080912.GA3409@linux-x5ow.site>
References: <20170113034001.29202-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170113034001.29202-1-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 13, 2017 at 11:40:01AM +0800, Fam Zheng wrote:
> The parameter name should be wwpn instead of wwnn.
> 
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---

Yup, looks good
Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
