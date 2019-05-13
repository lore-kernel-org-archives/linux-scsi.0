From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v1 0/3] scsi: ufs: add error handlings of auto-hibern8
Date: Mon, 13 May 2019 16:51:04 +0200
Message-ID: <55818bc4-d464-bb35-25bb-9ef87af8224e@free.fr>
References: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
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
To: Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, pedrom.sousa@synopsys.com
Cc: andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, vivek.gautam@codeaurora.org, matthias.bgg@gmail.com, sayalil@codeaurora.org, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

On 13/05/2019 16:36, Stanley Chu wrote:

> Currently auto-hibern8 is activated if host supports
> auto-hibern8 capability. However no error handlings are existed thus
> this feature is kind of risky.

This last sentence is not very idiomatic.

I would suggest:
"However, error-handling is not implemented, which makes the feature
somewhat risky."

> If "Hibernate Enter" or "Hibernate Exit" fail happens

I would suggest:
If either "Hibernate Enter" or "Hibernate Exit" fail during ...

> during auto-hibern8 flow, the corresponding interrupt
> "UIC_HIBERNATE_ENTER" or "UIC_HIBERNATE_EXIT" shall be raised
> according to UFS specification.
> 
> This patch adds auto-hibern8 error handlings:

error-handling

> - Monitor "Hibernate Enter" and "Hibernate Exit" interrupts after
>   auto-hibern8 feature is activated.

I just want to take this opportunity to ask a rhetorical question.

Who in the Great Heavens thought it would be a good idea to call the
feature "auto-hibern8" ?

Was it really worth it to save 2 characters by writing "8" instead
of "ate" ?

This bugs me so much that I just might send a patch to fix it up.

Regards.
