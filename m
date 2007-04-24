From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 2/7] genhd: expose AN to user space
Date: Tue, 24 Apr 2007 17:05:07 +0900
Message-ID: <462DBA33.9060207@gmail.com>
References: <20070424074856.005152262@intel.com> <20070423165950.7d64bd8e.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070423165950.7d64bd8e.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> +static struct disk_attribute disk_attr_capability = {
> +	.attr = {.name = "capability_flags", .mode = S_IRUGO },
> +	.show	= disk_capability_read
> +};

How about just "capability"?  I think that would be more consistent with
other attributes.

-- 
tejun
