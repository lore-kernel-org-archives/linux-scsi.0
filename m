From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/5] scsi: ufs: Fix regulator operations and remove
 "<name>-fixed-regulator" device tree property
Date: Fri, 29 Mar 2019 10:21:30 -0400
Message-ID: <yq1r2aprcb9.fsf@oracle.com>
References: <1553764587-26357-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1553764587-26357-1-git-send-email-stanley.chu@mediatek.com>
 (Stanley Chu's message of "Thu, 28 Mar 2019 17:16:22 +0800")
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
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, marc.w.gonzalez@free.fr, vivek.gautam@codeaurora.org, subhashj@codeaurora.org, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, avri.altman@wdc.com, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, alim.akhtar@samsung.com, matthias.bgg@gmail.com, sayalil@codeaurora.org, pedrom.sousa@synopsys.com, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org


Stanley,

> Upload v4 to fix little commit messages and invite more platform
> reviewers.
>
> This patch series fixes UFS regulator operations, including voltage
> and current (re-)configuration flow during UFS initialization and
> power modes switching.
>
> In the end, remove "<name>-fixed-regulator" device tree property
> because it is not necessary anymore after fixes.

Applied to 5.2/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
