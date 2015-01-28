From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_SMART PIO mode command.
Date: Wed, 28 Jan 2015 09:54:21 +0530
Message-ID: <CAOHikRBBG2p7kBn=bwP9rw0RYecvjNqz-zAiHeKT4+TyP8sCoA@mail.gmail.com>
References: <1422381371-11361-1-git-send-email-stripathi@apm.com>
 <1422381371-11361-2-git-send-email-stripathi@apm.com>
 <20150127181950.GE12314@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150127181950.GE12314@htj.dyndns.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Tejun Heo <tj@kernel.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Mark Langsdorf <mlangsdo@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Olof Johansson <olof@lixom.net>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 27, 2015 at 11:26:11PM +0530, Suman Tripathi wrote:
> This patch addresses the issue with ATA_CMD_SMART pio mode
> command for enumeration and device detection with ATA devices.It is the
> same issue as in patch
>
> www.spinics.net/lists/linux-ide/msg49092.html

The link is broken.  Can you please include at least a brief
explanation of the problem and preferably link to something more
permanant (commit ID, http://lkml.kernel.org/g/MSG_ID)?
Ok some problem might be there, But the link is opening. Sure I will
add the explanation rather than providing a link in the next version


On Tue, Jan 27, 2015 at 11:49 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Jan 27, 2015 at 11:26:11PM +0530, Suman Tripathi wrote:
>> This patch addresses the issue with ATA_CMD_SMART pio mode
>> command for enumeration and device detection with ATA devices.It is the
>> same issue as in patch
>>
>> www.spinics.net/lists/linux-ide/msg49092.html
>
> The link is broken.  Can you please include at least a brief
> explanation of the problem and preferably link to something more
> permanant (commit ID, http://lkml.kernel.org/g/MSG_ID)?
>
> Thanks.
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
