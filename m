From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs-mediatek: Avoid using ret uninitialized in
 ufs_mtk_setup_clocks
Date: Wed, 20 Mar 2019 20:10:38 -0400
Message-ID: <yq1a7hp6q9t.fsf@oracle.com>
References: <20190320180340.25795-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190320180340.25795-1-natechancellor@gmail.com> (Nathan
 Chancellor's message of "Wed, 20 Mar 2019 11:03:40 -0700")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, clang-built-linux@googlegroups.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org, Avri Altman <avri.altman@wdc.com>, linux-mediatek@lists.infradead.org, Alim Akhtar <alim.akhtar@samsung.com>, Matthias Brugger <matthias.bgg@gmail.com>, Stanley Chu <stanley.chu@mediatek.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Remove the default case and initialize ret to -EINVAL to properly fix
> this warning.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
