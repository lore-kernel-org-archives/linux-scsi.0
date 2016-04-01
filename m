From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v12 3/9] added UFS 2.0 capabilities
Date: Fri, 1 Apr 2016 10:19:15 +0100
Message-ID: <56FE3D13.6070504@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <40585ae835f02d3b5550a32553b2189754e365b6.1459448160.git.jpinto@synopsys.com>
 <1459455981.23778.31.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459455981.23778.31.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>, "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "gbroner@codeaurora.org" <gbroner@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "CARLOS.PALMINHA@synopsys.com" <CARLOS.PALMINHA@synopsys.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "julian.calaby@gmail.com" <julian.calaby@gmail.com>, "arnd@arndb.de" <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

On 3/31/2016 9:27 PM, Winkler, Tomas wrote:
> On Thu, 2016-03-31 at 19:57 +0100, Joao Pinto wrote:
>> Adding UFS 2.0 support to the UFS core driver.
>>
>> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> 
> Looks good to me, though not tested yet
> Tomas

I have tested the build in a x86 and ARC. Also tested the functionality by using
a HAPS-DX FPGA with the UFS 2.0 design + MPHY G210.

> 
>> ---
>> Changes v11->v12 (Tomas Winkler):
>> - devicetree binding tweak was moved to a separated patch
>> - unipro tweaks were moved to a separated patch
>> - ufshcd_compose_upiu was decomposed in 2 functions

[snip]

>> +enum {
>> +	UTP_CMD_TYPE_UFS_STORAGE	= 0x1,
>> +};
>> +
>>  enum {
>>  	UTP_SCSI_COMMAND		= 0x00000000,
>>  	UTP_NATIVE_UFS_COMMAND		= 0x10000000,

If you need anything else, please let me know.

Thanks.
Joao
