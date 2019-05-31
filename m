From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: clean some unneeded #ifdef MODULE
Date: Fri, 31 May 2019 18:15:24 +0300
Message-ID: <1559315724.2878.7.camel@linux.ibm.com>
References: <1559315344-10384-1-git-send-email-info@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559315344-10384-1-git-send-email-info@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <info@metux.net>, linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, jdelvare@suse.com, linux@roeck-us.net, khalid@gonehiking.org, martin.petersen@oracle.com, aacraid@microsemi.com, linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2019-05-31 at 17:09 +0200, Enrico Weigelt, metux IT consult
wrote:
> Hi folks,
> 
> here're some patches that clean up uncessary cases of #ifdef MODULE.
> These ifdef's just exlude MODULE_DEVICE_TABLE's when the kernel is
> built w/o module support. As MODULE_DEVICE_TABLE() macro already
> checks for that, these extra #ifdef's shouldn't be necessary.

Isn't the problem the #ifdefs are trying to solve a complaint about an
unused variable in the non-module case? if so, is that fixed some other
way?

James
