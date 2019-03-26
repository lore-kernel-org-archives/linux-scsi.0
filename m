From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] drivers: ufs: Add missing MODULE_* information
Date: Mon, 25 Mar 2019 22:10:32 -0400
Message-ID: <yq17ecm1j3b.fsf@oracle.com>
References: <20190321132444.28659-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190321132444.28659-1-anders.roxell@linaro.org> (Anders
 Roxell's message of "Thu, 21 Mar 2019 14:24:44 +0100")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Anders Roxell <anders.roxell@linaro.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, jejb@linux.ibm.com, linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Anders,

> When building the ufs-mediatek module the following warning shows up:
>
> WARNING: modpost: missing MODULE_LICENSE() in
>   drivers/scsi/ufs/ufs-mediatek.o
>
> Rework to add MODULE_LICENSE,MODULE_AUTHOR and MODULE_DESCRIPTION.

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
