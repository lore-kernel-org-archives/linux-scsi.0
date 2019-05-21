From: Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH v4 2/3] scsi: ufs: Introduce
 ufshcd_is_auto_hibern8_supported()
Date: Tue, 21 May 2019 14:29:45 +0800
Message-ID: <1558420185.660.9.camel@mtkswgap22>
References: <1558361445-30994-1-git-send-email-stanley.chu@mediatek.com>
 <1558361445-30994-3-git-send-email-stanley.chu@mediatek.com>
 <SN6PR04MB4925EAB455D857AEB055258FFC070@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <SN6PR04MB4925EAB455D857AEB055258FFC070@SN6PR04MB4925.namprd04.prod.outlook.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Avri Altman <Avri.Altman@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "beanhuo@micron.com" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org

Hi Avri,

On Tue, 2019-05-21 at 06:18 +0000, Avri Altman wrote:
> > 
> > ufshcd_is_auto_hibern8_supported() will be used elsewhere
> > in the driver, thus refactor it for preparation.
> You missed a couple of spots, e.g. in ufshcd_auto_hibern8_enable and in ufs-sysfs.

Yes...
Will re-factor them as well in next version.

> 
> Thanks,
> Avri

Thanks,
Stanley
