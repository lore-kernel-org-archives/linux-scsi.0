From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 0/5] libsas: Some logging tidy-up
Date: Thu, 15 Nov 2018 04:34:10 -0800
Message-ID: <484c6e88e1899cf7f0b373a8bf12b55f19f7fd8c.camel@perches.com>
References: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-11-15 at 18:20 +0800, John Garry wrote:
> This patchset presents some logging tidy-up, namely removing the printk
> wrappers and using pr_XXX() instead.
> 
> In addition, some log levels are revised, as previous levels (generally
> debug) were too low.

Seems sensible, thanks.
