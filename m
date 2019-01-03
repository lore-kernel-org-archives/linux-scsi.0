From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 1/1] scsi: Synchronize request queue PM status only on
 successful resume
Date: Thu, 3 Jan 2019 10:23:33 +0200
Message-ID: <20190103082333.GL2469@lahna.fi.intel.com>
References: <1546498395-4184-1-git-send-email-stanley.chu@mediatek.com>
 <1546498395-4184-3-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1546498395-4184-3-git-send-email-stanley.chu@mediatek.com>
Sender: stable-owner@vger.kernel.org
To: stanley.chu@mediatek.com
Cc: linux-scsi@vger.kernel.org, wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com, kuohong.wang@mediatek.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Thu, Jan 03, 2019 at 02:53:15PM +0800, stanley.chu@mediatek.com wrote:
> From: Stanley Chu <stanley.chu@mediatek.com>
> 
> The commit 356fd2663cff ("scsi: Set request queue runtime PM status
> back to active on resume") fixed up the inconsistent RPM status between
> request queue and device. However changing request queue RPM status
> shall be done only on successful resume, otherwise status may be still
> inconsistent as below,
> 
> Request queue: RPM_ACTIVE
> Device: RPM_SUSPENDED
> 
> This ends up soft lockup because requests can be submitted to
> underlying devices but those devices and their required resource
> are not resumed.

It would be good to add some example of the soft lockup you are seeing
here.

> Fixes: 356fd2663cff ("scsi: Set request queue runtime PM status
> back to active on resume")

You don't need to wrap this.

The change itself looks fine.
