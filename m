From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 10:49:22 -0500
Message-ID: <CAOS58YMEXhuUApywcOBGh4mFHKhiDJw2pKLN5i80ocvqRX4UiQ@mail.gmail.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
	<1384905197-3566-4-git-send-email-lho@apm.com>
	<20131120150658.GB28946@htj.dyndns.org>
	<201311201641.20230.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201311201641.20230.arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Loc Ho <lho@apm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, jcm@redhat.com, linux-ide <linux-ide@vger.kernel.org>, olof@lixom.net, Tuan Phan <tphan@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Arnd.

On Wed, Nov 20, 2013 at 10:41 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> It needs to be in drivers/phy, which is currently being prepared for
> the next merge window and which contains the generic interface used
> in this driver.

Ah, cool, so I don't need to worry about this one, right?

Thanks a lot. :)

-- 
tejun
