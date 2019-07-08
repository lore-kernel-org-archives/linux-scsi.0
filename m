From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v1 0/3] scsi: ufs: Provide fatal and auto-hibern8 error
 history
Date: Mon, 8 Jul 2019 08:25:15 +0000
Message-ID: <SN6PR04MB4925ED3707277B9C3E582537FCF60@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1562560677-3985-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1562560677-3985-1-git-send-email-stanley.chu@mediatek.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Stanley Chu <stanley.chu@mediatek.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
Cc: "sthumma@codeaurora.org" <sthumma@codeaurora.org>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "ygardi@codeaurora.org" <ygardi@codeaurora.org>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "beanhuo@micron.com" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org

This series looks good to me.

Thanks,
Avri

> 
> This patch set provides more information of fatal errros and auto-hibern8
> errors
> to improve debugging by keeping their error history as completed as possible.
> 
> Stanley Chu (3):
>   scsi: ufs: Change names related to error history
>   scsi: ufs: Add fatal and auto-hibern8 error history
>   scsi: ufs: Do not reset error history during host reset
> 
>  drivers/scsi/ufs/ufshcd.c | 57 +++++++++++++++++++--------------------
>  drivers/scsi/ufs/ufshcd.h | 26 +++++++++++-------
>  2 files changed, 44 insertions(+), 39 deletions(-)
> 
> --
> 2.18.0
