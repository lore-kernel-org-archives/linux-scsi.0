From: Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v1 0/3] scsi: ufs: add error handlings of auto-hibern8
Date: Tue, 14 May 2019 14:25:01 +0800
Message-ID: <1557815101.24427.7.camel@mtkswgap22>
References: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
 <55818bc4-d464-bb35-25bb-9ef87af8224e@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <55818bc4-d464-bb35-25bb-9ef87af8224e@free.fr>
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
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, vivek.gautam@codeaurora.org, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, subhashj@codeaurora.org, evgreen@chromium.org, avri.altman@wdc.com, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, alim.akhtar@samsung.com, matthias.bgg@gmail.com, sayalil@codeaurora.org, pedrom.sousa@synopsys.com, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Hi Marc,

Thank you so much for below suggestions. I will fix them all in next
version.

On Mon, 2019-05-13 at 16:51 +0200, Marc Gonzalez wrote:
> On 13/05/2019 16:36, Stanley Chu wrote:
> 
> > Currently auto-hibern8 is activated if host supports
> > auto-hibern8 capability. However no error handlings are existed thus
> > this feature is kind of risky.
> 
> This last sentence is not very idiomatic.
> 
> I would suggest:
> "However, error-handling is not implemented, which makes the feature
> somewhat risky."
> 
> > If "Hibernate Enter" or "Hibernate Exit" fail happens
> 
> I would suggest:
> If either "Hibernate Enter" or "Hibernate Exit" fail during ...
> 
> > during auto-hibern8 flow, the corresponding interrupt
> > "UIC_HIBERNATE_ENTER" or "UIC_HIBERNATE_EXIT" shall be raised
> > according to UFS specification.
> > 
> > This patch adds auto-hibern8 error handlings:
> 
> error-handling
> 
> > - Monitor "Hibernate Enter" and "Hibernate Exit" interrupts after
> >   auto-hibern8 feature is activated.
> 
> I just want to take this opportunity to ask a rhetorical question.
> 
> Who in the Great Heavens thought it would be a good idea to call the
> feature "auto-hibern8" ?
> 
> Was it really worth it to save 2 characters by writing "8" instead
> of "ate" ?
> 
> This bugs me so much that I just might send a patch to fix it up.

As far as I know, the term "HIBERN8" is mentioned in all UFS related
specifications, like UFS, UFSHCI, UniPro and M-PHY. So probably this
abbreviation has existed for a long time.

> 
> Regards.

Thanks,

Stanley
