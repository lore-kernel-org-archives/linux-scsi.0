From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 3/9] ufs: sysfs: geometry descriptor
Date: Wed, 27 Dec 2017 16:20:41 +0100
Message-ID: <20171227152041.GD20967@kroah.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514387627-27817-4-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514387627-27817-4-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 27, 2017 at 05:13:41PM +0200, Stanislav Nijnikov wrote:
> This patch introduces a sysfs group entry for the UFS geometry descriptor
> parameters. The group adds "geometry_descriptor" folder under the UFS
> driver sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The parameters
> are shown as hexadecimal numbers. The full information about the parameters
> could be found at UFS specifications 2.1.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
