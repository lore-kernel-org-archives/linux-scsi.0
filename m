From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: clean some unneeded #ifdef MODULE
Date: Fri, 31 May 2019 17:09:01 +0200
Message-ID: <1559315344-10384-1-git-send-email-info@metux.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, jdelvare@suse.com, linux@roeck-us.net, khalid@gonehiking.org, jejb@linux.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com, linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi folks,

here're some patches that clean up uncessary cases of #ifdef MODULE.
These ifdef's just exlude MODULE_DEVICE_TABLE's when the kernel is
built w/o module support. As MODULE_DEVICE_TABLE() macro already
checks for that, these extra #ifdef's shouldn't be necessary.


--mtx
