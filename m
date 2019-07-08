From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/3] scsi: ufs: Provide fatal and auto-hibern8 error history
Date: Mon, 8 Jul 2019 12:37:54 +0800
Message-ID: <1562560677-3985-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, pedrom.sousa@synopsys.com
Cc: sthumma@codeaurora.org, marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, peter.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, ygardi@codeaurora.org, matthias.bgg@gmail.com, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

This patch set provides more information of fatal errros and auto-hibern8 errors
to improve debugging by keeping their error history as completed as possible.

Stanley Chu (3):
  scsi: ufs: Change names related to error history
  scsi: ufs: Add fatal and auto-hibern8 error history
  scsi: ufs: Do not reset error history during host reset

 drivers/scsi/ufs/ufshcd.c | 57 +++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h | 26 +++++++++++-------
 2 files changed, 44 insertions(+), 39 deletions(-)

-- 
2.18.0
