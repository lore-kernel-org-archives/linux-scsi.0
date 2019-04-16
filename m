From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: Print real incorrect request response code
Date: Mon, 15 Apr 2019 22:18:03 -0400
Message-ID: <yq11s22hew4.fsf@oracle.com>
References: <1555331018-32734-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1555331018-32734-1-git-send-email-stanley.chu@mediatek.com>
 (Stanley Chu's message of "Mon, 15 Apr 2019 20:23:38 +0800")
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
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, avri.altman@wdc.com, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, alim.akhtar@samsung.com, matthias.bgg@gmail.com, pedrom.sousa@synopsys.com, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org


Stanley,

> If UFS device responds an unknown request response code, we can not
> know what it was via logs because the code is replaced by "DID_ERROR
> << 16" before log printing.
>
> Fix this to provide precise request response code information for
> easier issue breakdown.

Applied to 5.2/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
