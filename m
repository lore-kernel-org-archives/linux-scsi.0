From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: remove unneeded #ifdef MODULE
Date: Sat,  1 Jun 2019 16:01:37 +0200
Message-ID: <1559397700-15585-1-git-send-email-info@metux.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, jdelvare@suse.com, linux@roeck-us.net, khalid@gonehiking.org, jejb@linux.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com, linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi folks,

here're some patches that remove some (IMHO) unncessary cases of #ifdef MODULE
These basically switch off calls to MODULE_DEVICE_TABLE() macro, which already
checks for MODULE symbol on its own.

have fun
--mtx 
