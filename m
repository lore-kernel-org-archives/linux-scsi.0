From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v2 8/8] scsi: ufs: connect to RPMB subsystem
Date: Fri, 8 Apr 2016 10:24:21 +0100
Message-ID: <570778C5.5060706@synopsys.com>
References: <1459768284-26997-1-git-send-email-tomas.winkler@intel.com>
 <1459768284-26997-9-git-send-email-tomas.winkler@intel.com>
 <5704CE0B.2010700@synopsys.com> <1460063682.4468.7.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1460063682.4468.7.camel@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "luto@kernel.org" <luto@kernel.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "ygardi@codeaurora.org" <ygardi@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Usyskin, Alexander" <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi!

On 4/7/2016 10:15 PM, Winkler, Tomas wrote:
> On Wed, 2016-04-06 at 09:51 +0100, Joao Pinto wrote:
>> Hi!
>>
>> On 4/4/2016 12:11 PM, Tomas Winkler wrote:
>>> Register UFS RPMB LUN with the RPMB subsystem and provide
>>> implementation for the RPMB access operations. RPMB partition is
>>> accessed via a sequence of security protocol in and security
>>> protocol
>>> out commands with UFS specific parameters. This multi step process
>>> is
>>> abstracted into 4 basic RPMB commands.
>>
>> [snip]
>>
>>>  	 * "UFS device" W-LU.
>>>  	 */
>>>  	struct scsi_device *sdev_ufs_device;
>>> +	struct scsi_device *sdev_ufs_rpmb;
>>>  
>>>  	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
>>>  	enum uic_link_state uic_link_state;
>>>
>>
>> I have a UFS device emulator that has the RPMB capability. What are
>> the expected
>> good results for me to validate?
> 
> Hi Joao, thanks for that. I'm attaching an archive with few basic
> samples via user space interface. 
> You should run the program key first (program-key.sh), just don't do it
> on a real device it's one in life time operation. 

No attachment received.

> 
> Thanks
> Tomas
> 

Thanks,
Joao

