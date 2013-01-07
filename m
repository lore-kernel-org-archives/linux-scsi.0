From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 4/4] sd: change to auto suspend mode
Date: Mon, 07 Jan 2013 17:31:40 +0800
Message-ID: <50EA95FC.2020103@intel.com>
References: <1357461697-4219-1-git-send-email-aaron.lu@intel.com> <1357461697-4219-5-git-send-email-aaron.lu@intel.com> <2040976.slu5Ii8g67@linux-5eaq.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <2040976.slu5Ii8g67@linux-5eaq.site>
Sender: linux-pm-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On 01/07/2013 05:19 PM, Oliver Neukum wrote:
> On Sunday 06 January 2013 16:41:37 Aaron Lu wrote:
>> From: Lin Ming <ming.m.lin@intel.com>
>>
>> Uses block layer runtime pm helper functions in
>> scsi_runtime_suspend/resume.
>> Remove scsi_autopm_* from sd open/release path and check_events path.
>> And remove the quiesce call in runtime suspend path, as we know there is
>> no request to quiesce for the device.
> 
> How does this handle ioctl() ?

The ioctl code will allocate a new request and execute it through block
layer API, which involves adding the request to the queue and releasing
it when it is finished.

Thanks,
Aaron

