From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v3 6/8] scsi: ufs: qcom: Expose the reset controller for
 PHY
Date: Wed, 6 Feb 2019 17:42:01 +0530
Message-ID: <720c0327-e6b7-67f8-7756-d3861d66dede@ti.com>
References: <20190205185902.106085-1-evgreen@chromium.org>
 <20190205185902.106085-7-evgreen@chromium.org>
 <10ea3fe2-e331-0342-cfad-eccce3753d2e@ti.com>
 <8d94b1ae-8084-ed06-19ed-36dd99837703@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8d94b1ae-8084-ed06-19ed-36dd99837703@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>, Evan Green <evgreen@chromium.org>, Andy Gross <andy.gross@linaro.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Marc,

On 06/02/19 5:24 PM, Marc Gonzalez wrote:
> On 06/02/2019 12:42, Kishon Vijay Abraham I wrote:
> 
>> On 06/02/19 12:29 AM, Evan Green wrote:
>>
>>> Expose a reset controller that the phy will later use to control its
>>> own PHY reset in the UFS controller. This will enable the combining
>>> of PHY init functionality into a single function.
>>>
>>> Signed-off-by: Evan Green <evgreen@chromium.org>
>>
>> I'd like to get ACK from scsi/ufs/ MAINTAINER Vinayak for me merge it in PHY tree.
> 
> Kishon, I haven't seen any messages from Vinayak in a while.
> 
> https://patchwork.kernel.org/patch/10795501/
> 
> New reviewers are Alim, Avri, and Pedro (haven't heard from Pedro yet).

Thanks for letting me know.

Alim, Avri,

Can you give your ACK for this patch?

Thanks
Kishon
> 
> Regards.
> 
