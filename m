From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 6/9] ufs: sysfs: string descriptors
Date: Wed, 27 Dec 2017 16:22:37 +0100
Message-ID: <20171227152237.GG20967@kroah.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514387627-27817-7-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdL0P1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Dec 2017 10:27:55 -0500
Content-Disposition: inline
In-Reply-To: <1514387627-27817-7-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com

On Wed, Dec 27, 2017 at 05:13:44PM +0200, Stanislav Nijnikov wrote:
> This patch introduces a sysfs group entry for the UFS string descriptors.
> The group adds "string_descriptors" folder under the UFS driver
> sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The folder will contain
> 5 files that will show string values defined by the UFS spec:
> a manufacturer name, a product name, an OEM id, a serial number and a
> product revision.  The full information about the string descriptors
> could be found at UFS specifications 2.1.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
