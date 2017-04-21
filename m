From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] scsi: mpt3sas: remove redundant wmb
Date: Fri, 21 Apr 2017 10:10:57 -0500
Message-ID: <c83bd8cf-cd83-f1d2-b982-a0cacf81370f@linux.vnet.ibm.com>
References: <1491591978-17880-1-git-send-email-okaya@codeaurora.org>
 <yq1y3uvq0c1.fsf@oracle.com>
 <CAK=zhgpmcmq-CnWuU9=WRJpAaEduw63LSPLE9yZzF_sUHkM4AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK=zhgpmcmq-CnWuU9=WRJpAaEduw63LSPLE9yZzF_sUHkM4AA@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Chaitra P B <chaitra.basappa@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, timur@codeaurora.org, Sathya Prakash <sathya.prakash@broadcom.com>, open list <linux-kernel@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 04/21/2017 02:56 AM, Sreekanth Reddy wrote:
> On Thu, Apr 20, 2017 at 7:58 AM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>> Sinan Kaya <okaya@codeaurora.org> writes:
>>
>>> Due to relaxed ordering requirements on multiple architectures,
>>> drivers are required to use wmb/rmb/mb combinations when they need to
>>> guarantee observability between the memory and the HW.
>>>
>>> The mpt3sas driver is already using wmb() for this purpose.  However,
>>> it issues a writel following wmb(). writel() function on arm/arm64
>>> arhictectures have an embedded wmb() call inside.
> 
> [Sreekanth] Whether same thing applicable for SPARC & POWER
> architectures. If yes then we are fine with this patch changes.

This is also true for Power. 

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
