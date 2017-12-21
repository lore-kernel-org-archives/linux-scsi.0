From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2 v3] scsi: ufs: introduce static sysfs entries
Date: Thu, 21 Dec 2017 08:59:57 +0100
Message-ID: <20171221075957.GC9645@kroah.com>
References: <20171220191631.50329-1-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171220191631.50329-1-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@google.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 20, 2017 at 11:16:30AM -0800, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> This patch introduces attribute group to show existing sysfs entries.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
> 
> Change log from v1:
>  - use ATTRIBUTE_GROUPS and sysfs_create_groups()

Nice change, thanks.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
