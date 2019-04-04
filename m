From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] scsi: dt-bindings: ufs: Remove
 "<name>-fixed-regulator" property and add VCC capability on MediaTek UFS
 driver
Date: Wed, 03 Apr 2019 23:26:40 -0400
Message-ID: <yq1imvutpqn.fsf@oracle.com>
References: <1553873568-9177-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1553873568-9177-1-git-send-email-stanley.chu@mediatek.com>
 (Stanley Chu's message of "Fri, 29 Mar 2019 23:32:46 +0800")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Stanley Chu <stanley.chu@mediatek.com>
Cc: devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, robh@kernel.org, vivek.gautam@codeaurora.org, subhashj@codeaurora.org, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, avri.altman@wdc.com, robh+dt@kernel.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, alim.akhtar@samsung.com, matthias.bgg@gmail.com, sayalil@codeaurora.org, pedrom.sousa@synopsys.com, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org


Stanley,

> Now we can remove custom device tree property "<name>-fixed-regulator" for
> UFS because,

> Besides, add VCC supply capability on MediaTek UFS driver.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
