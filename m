From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY framework
Date: Thu, 27 Feb 2014 11:57:44 -0800
Message-ID: <CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
	<1393524848-8207-2-git-send-email-lho@apm.com>
	<20140227190102.GB4862@saruman.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140227190102.GB4862@saruman.home>
Sender: linux-ide-owner@vger.kernel.org
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Balbi,

> On Thu, Feb 27, 2014 at 11:14:05AM -0700, Loc Ho wrote:
>> This patch adds function set_speed to the generic PHY framework operation
>> structure. This function can be called to instruct the PHY underlying layer
>> at specified lane to configure for specified speed in hertz.
>
> why ? looks like clk_set_rate() is your friend here. Can you be more
> descriptive of the use case ? When will this be used ?
>

The phy_set_speed is used to configure the operation speed of the PHY
at run-time. The clock interface in general is used to configure the
clock input to the IP. I don't believe they are the same thing. Maybe
it will be clear in my response to your second email

-Loc
