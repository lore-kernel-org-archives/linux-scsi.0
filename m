From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 1/1] scsi: Synchronize request queue PM status only
 on successful resume
Date: Thu, 03 Jan 2019 11:03:47 -0800
Message-ID: <1546542227.163063.18.camel@acm.org>
References: <1546524485-25610-1-git-send-email-stanley.chu@mediatek.com>
         <1546524485-25610-3-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1546524485-25610-3-git-send-email-stanley.chu@mediatek.com>
Sender: stable-owner@vger.kernel.org
To: stanley.chu@mediatek.com, linux-scsi@vger.kernel.org
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com, mika.westerberg@linux.intel.com, kuohong.wang@mediatek.com, peter.wang@mediatek.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-01-03 at 22:08 +-0800, stanley.chu+AEA-mediatek.com wrote:
+AD4 Fixes: 356fd2663cff (scsi: Set request queue runtime PM status
+AD4 back to active on resume)

Please do not split +ACI-Fixes+ACI lines. Otherwise this patch looks good to me.
Hence:

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
