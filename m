From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v3 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Wed, 27 Nov 2013 11:22:53 +0530
Message-ID: <529588B5.1070109@ti.com>
References: <1384465153-29902-1-git-send-email-lho@apm.com>	<1384465153-29902-3-git-send-email-lho@apm.com>	<1384465153-29902-4-git-send-email-lho@apm.com>	<201311151448.16279.arnd@arndb.de>	<CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com>	<CAPw-ZTn1N7+EFu9L6U+P9=9ii3k1BjycYXdNCdxCVPb8SaJWxA@mail.gmail.com>	<529473DD.1090804@ti.com>
 <CAPw-ZTmPgYA+saJPVvB17VOPouDGvR0rd0nrZWi0j3zE7cc2rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAPw-ZTmPgYA+saJPVvB17VOPouDGvR0rd0nrZWi0j3zE7cc2rg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Jon Masters <jcm@redhat.com>, Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 26 November 2013 10:11 PM, Loc Ho wrote:
> Hi,
> 
>>> int set_speed(struct *phy, int lane, u64 speed);
>>
>> it should be phy_set_speed.
> [Loc Ho]
> But your other functions don't repeat the prefix "phy"?

refer include/linux/phy/phy.h..

int phy_init(struct phy *phy);
int phy_exit(struct phy *phy);
int phy_power_on(struct phy *phy);
int phy_power_off(struct phy *phy);

??

> 
>>>
>>> where lane indicates the lane of the PHY and speed is the PHY speed in hertz.
>>
>> Does lane here means the number of lanes? Is the lane also obtained after the
>> training sequence?
> [Loc Ho]
> Lane here is the lane with you are changing the speed. If there are
> two lanes, then 0 parameter would change lane 0. 1 would change lane
> 1.

can different lanes operate at different speed at the same time?

Thanks
Kishon
