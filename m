From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 19:46:52 +0100
Message-ID: <201311201946.52659.arnd@arndb.de>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
 <201311201641.20230.arnd@arndb.de>
 <CAOS58YMEXhuUApywcOBGh4mFHKhiDJw2pKLN5i80ocvqRX4UiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAOS58YMEXhuUApywcOBGh4mFHKhiDJw2pKLN5i80ocvqRX4UiQ@mail.gmail.com>
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
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, jcm@redhat.com, linux-ide <linux-ide@vger.kernel.org>, Loc Ho <lho@apm.com>, olof@lixom.net, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 20 November 2013, Tejun Heo wrote:

> On Wed, Nov 20, 2013 at 10:41 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > It needs to be in drivers/phy, which is currently being prepared for
> > the next merge window and which contains the generic interface used
> > in this driver.
> 
> Ah, cool, so I don't need to worry about this one, right?

Right, we just need to make sure the patches are staged the right
way when they go through different subsystem maintainers. There
should not be any build-time dependencies, so I think it won't
be an issue.

	Arnd
