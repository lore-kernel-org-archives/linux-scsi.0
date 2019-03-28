From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 0/5] scsi: ufs: Fix regulator operations and remove
 "<name>-fixed-regulator" device tree property
Date: Thu, 28 Mar 2019 17:16:22 +0800
Message-ID: <1553764587-26357-1-git-send-email-stanley.chu@mediatek.com>
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
Cc: marc.w.gonzalez@free.fr, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, vivek.gautam@codeaurora.org, matthias.bgg@gmail.com, sayalil@codeaurora.org, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Upload v4 to fix little commit messages and invite more platform reviewers.

This patch series fixes UFS regulator operations, including voltage and current (re-)configuration flow during UFS initialization and power modes switching.

In the end, remove "<name>-fixed-regulator" device tree property because it is not necessary anymore after fixes.

V4:
- Fix commit messages (Avri Altman).
- Fix tags (Alim Akhtar).
- Invite more reviewers.

V3:
- Fix and add more details in commit messages.
- Add one patch "scsi: ufs: Avoid configuring undefined voltage range on a regulator".

V2:
- Add two patches to prepare to and remove "<name>-fixed-regulator" device tree property.
- Add more details on patch "scsi: ufs: remove unused min_uA field in struct ufs_vreg" (Marc Gonzalez).

Stanley Chu (5):
  scsi: ufs: Remove unused min_uA field in struct ufs_vreg
  scsi: ufs: Avoid configuring regulator with undefined voltage range
  scsi: ufs: Fix regulator load and icc-level configuration
  scsi: ufs: Change "<name>-max-microamp" to non-mandatory property
  scsi: ufs: Remove "<name>-fixed-regulator" device tree property

 drivers/scsi/ufs/ufs.h           |  1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c | 14 +++-----------
 drivers/scsi/ufs/ufshcd.c        | 28 ++++++++++++++++++++--------
 3 files changed, 23 insertions(+), 20 deletions(-)

-- 
2.18.0
