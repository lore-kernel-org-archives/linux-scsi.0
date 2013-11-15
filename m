From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY
 driver binding documentation
Date: Fri, 15 Nov 2013 08:22:02 -0800
Message-ID: <CAPw-ZT=x3eTd_vgVgyu0HR7j2wmSfQkkSeCMJSJ_i3MTPwiM-g@mail.gmail.com>
References: <1384457519-21335-1-git-send-email-lho@apm.com>
	<1384457519-21335-2-git-send-email-lho@apm.com>
	<201311151335.09577.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201311151335.09577.arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>> +- CTLE0                        : PHY override parameters for channel 0 register REG1
>> +                         field CTLE_EQ. First value for Gen1, second value
>> +                         for Gen2, and third value for Gen3. Default is 0x2.
>> +- CTLE1                        : PHY override parameters for channel 1 register REG1
>> +                         field CTLE_EQ. First value for Gen1, second value
>> +                         for Gen2, and third value for Gen3. Default is 0x2.
>> +- PQ0                  : PHY override parameters for channel 0 register REG125
>> +                         field PQ_REG. First value for Gen1, second value
>> +                         for Gen2, and third value for Gen3. Default is 0xA.
>> +- PQ1                  : PHY override parameters for channel 1 register REG125
>> +                         field PQ_REG. First value for Gen1, second value
>> +                         for Gen2, and third value for Gen3. Default is 0xA.
>
> As mentioned before, I don't think putting register-level information into the binding
> is the right approach here.
>
[Loc Ho]
I don't want to change the driver for every possible customer or APM
boards out there. In general, if the board designer follows the board
design guideline, this isn't necessary. Unfortunately, I can not
control what customer do. If these setting is NOT driven by DTS, then
I or others may have to change the driver every time there is an new
board. Another option is pass them as module parameters.

-Loc
