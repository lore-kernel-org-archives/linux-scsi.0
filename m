From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: ufs: Use explicit access size in ufshcd_dump_regs
Date: Tue, 22 Jan 2019 21:13:33 -0500
Message-ID: <yq1o988m88i.fsf@oracle.com>
References: <3bf7ea8e-4cf2-1f9b-7f46-15609dfcad19@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <3bf7ea8e-4cf2-1f9b-7f46-15609dfcad19@free.fr> (Marc Gonzalez's
 message of "Tue, 11 Dec 2018 15:18:18 +0100")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: SCSI <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joao Pinto <jpinto@synopsys.com>, MSM <linux-arm-msm@vger.kernel.org>, Avri Altman <avri.altman@wdc.com>, Tomas Winkler <tomas.winkler@intel.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Robin Murphy <robin.murphy@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org


Marc,

> memcpy_fromio() doesn't provide any control over access size.
> For example, on arm64, it is implemented using readb and readq.
> This may trigger a synchronous external abort:

Applied to 5.0/scsi-fixes, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
