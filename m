From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v1] scsi: ufs: Use explicit access size in ufshcd_dump_regs
Date: Thu, 27 Dec 2018 16:54:21 +0100
Message-ID: <9ae9debe-5621-a729-e254-dbf1728dea99@free.fr>
References: <3bf7ea8e-4cf2-1f9b-7f46-15609dfcad19@free.fr>
 <5B8DA87D05A7694D9FA63FD143655C1B9DA52659@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B9DA52659@hasmsx108.ger.corp.intel.com>
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
To: Vinayak Holikatti <vinholikatti@gmail.com>, Joao Pinto <jpinto@synopsys.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, MSM <linux-arm-msm@vger.kernel.org>, Avri Altman <avri.altman@wdc.com>, "Winkler, Tomas" <tomas.winkler@intel.com>, Robin Murphy <robin.murphy@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 13/12/2018 23:34, Winkler, Tomas wrote:

> On 11/12/2018 15:18, Marc Gonzalez wrote:
> 
>> Fixes: ba80917d9932d ("scsi: ufs: ufshcd_dump_regs to use memcpy_fromio")
>> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
>
> LGTM

Vinayak, Joao,

What do you think?

Regards.
